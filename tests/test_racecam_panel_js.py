"""Node/JS checks for the RaceCam operator panel.

Covers:
  * Lua syntax of ClientScripts/RaceCam/panel_ui.lua (host lua5.4 via hostrun.sh)
  * JS syntax (Node `new Function`) and strict DOM-ID consistency
  * preservation of every broadcast control/hotkey from the original http.lua panel
  * #token=...&autoload=current boot handling (localStorage + replaceState + autoload)
  * routePlanner parity against amc-racecam/route_to_shots.py on three+ shapes

Run: python3 -m unittest tests.test_racecam_panel_js -v
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PANEL = ROOT / "ClientScripts/RaceCam/panel_ui.lua"
NODE = "/usr/local/bin/node"
HOSTRUN = "/opt/data/scripts/hostrun.sh"
LUAC_CHECK = "/opt/data/scripts/lua_syntax_check.sh"
REFPY = Path("/opt/data/workspace/amc-racecam")
SCRATCH = Path("/opt/data/cache/scratch")

sys.path.insert(0, str(REFPY))
import route_to_shots as rp_py  # noqa: E402

UNIVERSAL = ["start_line", "fly_up", "auto_trackside", "heli_follow", "follow_focus",
             "front_chase", "side_tracking", "orbit_hero", "route_flyover"]

# Every id the panel is allowed to reference. Strict, hand-maintained: no
# fabrication, and the test asserts BOTH directions against the real HTML.
VALID_IDS = {
    "banner", "tok", "rehb", "prog", "prv", "shot", "fov", "plan", "cd", "hb", "run",
    "queue", "qat", "sid", "pname", "pname_text",
    "live_current", "live_load_btn", "live_refresh", "live_events", "auto_start",
    "follow_leader", "track_file", "drop_zone", "saved_plans", "plans_refresh",
    "plan_load", "track_info", "track_canvas",
    "track_loader_card", "auto_apply", "paste_json", "paste_preview",
    "inbox_files", "inbox_load", "inbox_refresh", "standalone_badge",
    "pin_position", "pin_undo", "pin_clear", "pin_count", "pin_build",
    "obsurl", "obspw", "obsst", "obs_check", "obs_remember", "obsscene", "obssrc",
    "obsprev", "out",
}


# ---------------------------------------------------------------------------
# Node harness: lightweight browser stubs so the real panel JS can be executed.
# ---------------------------------------------------------------------------
MOCK_PREFIX = r"""
const realSetTimeout = globalThis.setTimeout;
globalThis.setTimeout = (fn, ms) => 0;          // suppress the 700 ms poll loop
const sleep = ms => new Promise(r => realSetTimeout(r, ms));
const els = {};
function mkEl(id){
  const o = {id:id, value:'', textContent:'', className:'', checked:false,
    disabled:false, style:{}, options:[], files:[], src:''};
  o.appendChild = c => { o.options.push(c); return c; };
  o.addEventListener = (ev, fn) => { (o._ev = o._ev || {})[ev] = fn; };
  o.click = () => {};
  o.getContext = () => null;                    // canvas not needed in Node
  Object.defineProperty(o, 'innerHTML', {
    get(){ return o._html || ''; },
    set(v){ o._html = v; if (v === '') o.options.length = 0; }
  });
  return o;
}
globalThis.document = {
  getElementById(id){ return els[id] || (els[id] = mkEl(id)); },
  createElement(tag){ return mkEl(tag); },
  addEventListener(){}
};
globalThis.window = globalThis;
function mkStore(){
  const m = new Map();
  return {getItem:k => m.has(k) ? m.get(k) : null,
          setItem:(k,v) => m.set(k, String(v)),
          removeItem:k => m.delete(k)};
}
globalThis.localStorage = mkStore();
globalThis.sessionStorage = mkStore();
globalThis.location = {hash:'', href:'http://127.0.0.1:8767/'};
const replaceStateCalls = [];
globalThis.history = {replaceState:(...a) => replaceStateCalls.push(a)};
const fetchLog = [];
globalThis.fetch = async (url, opts) => {
  fetchLog.push({url:url, opts:opts || {}});
  let j = {};
  if (url === '/api/state') j = {degraded:false, target_lost:false, shots:['start_line','corner_01_pan'],
                                 targets:['Driver'], rehearsal:false, running:false};
  else if (url === '/api/live_events') j = globalThis.__noLiveEvents ? {events:[]} : {events:[{name:'Current Trial', is_member:true,
    waypoints:[{x:0,y:0,z:0,gate_m:18},{x:4000,y:0,z:0,gate_m:18},{x:8000,y:0,z:0,gate_m:18}]}]};
  else if (url === '/api/plans') j = {plans:[]};
  else if (url === '/api/inbox') j = {has_drop_file:true, files:['event.json','route.txt']};
  else if (url && url.indexOf('/api/inbox_file?') === 0) j = globalThis.__inboxContent || '{}';
  else if (url === '/api/my_pos') {
    const i = (globalThis.__pinSeq = (globalThis.__pinSeq || 0) + 1);
    j = {x:i*1800.0, y:(i%2)*900.0, z:0, yaw:0};
  }
  return {json: async () => j,
          text: async () => (typeof j === 'string' ? j : JSON.stringify(j))};
};
globalThis.WebSocket = class { constructor(u){ this.url = u; this.readyState = 0; } send(){} close(){} };
globalThis.FileReader = class { readAsText(f){ this.result = (f && f._text) || ''; if (this.onload) this.onload(); } };
"""


def run_node(js: str, body: str, extra: str = "", timeout: int = 45) -> subprocess.CompletedProcess:
    """Evaluate the panel JS inside the mocked browser and return a JSON result."""
    source = (MOCK_PREFIX + "\nconst PANEL_JS = " + json.dumps(js) + ";\n" + extra + "\n"
              + "(async () => {\n" + body + "\n})();\n")
    SCRATCH.mkdir(parents=True, exist_ok=True)
    fd, path = tempfile.mkstemp(prefix="rc-panel-", suffix=".js", dir=str(SCRATCH))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(source)
        return subprocess.run([NODE, path], capture_output=True, text=True, timeout=timeout)
    finally:
        os.unlink(path)


def parse_result(proc: subprocess.CompletedProcess):
    if proc.returncode != 0:
        raise AssertionError("node failed rc=%s\nstdout=%s\nstderr=%s"
                             % (proc.returncode, proc.stdout[-3000:], proc.stderr[-3000:]))
    return json.loads(proc.stdout.strip().splitlines()[-1])


# ---------------------------------------------------------------------------
# Route fixtures shared by Python and Node
# ---------------------------------------------------------------------------
def closed_circuit():
    pts = [[0.0, 0.0, 0.0], [6000.0, 0.0, 120.0], [9500.0, 3500.0, 240.0],
           [6000.0, 7000.0, 120.0], [0.0, 7000.0, 0.0], [-3500.0, 3500.0, -80.0],
           [0.0, 0.0, 0.0]]
    return "closed-circuit", pts, [18.0] * len(pts)


def hillclimb():
    pts = [[i * 5000.0, (i % 2) * 2000.0, i * 300.0] for i in range(8)]
    return "hillclimb", pts, [18.0] * len(pts)


def sprint():
    pts = [[0.0, 0.0, 0.0], [4000.0, 0.0, 0.0], [8000.0, 0.0, 0.0]]
    return "sprint", pts, [18.0] * len(pts)


SHAPES = [closed_circuit, hillclimb, sprint]


def as_doc(name, pts, gates):
    return {"RouteName": name, "Waypoints": [
        {"Location": {"X": p[0], "Y": p[1], "Z": p[2]}, "Scale3D": {"Y": g}}
        for p, g in zip(pts, gates)]}


class PanelSourceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.html = cls.lua
        m = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S)
        assert m, "no <script> block in panel_ui.lua"
        cls.js = m.group(1)
        cls.html_ids = set(re.findall(r'id="([^"]+)"', cls.lua))
        cls.js_ids = set(re.findall(r"\$\('([^']+)'\)", cls.js))

    def test_lua_syntax(self):
        p = subprocess.run([HOSTRUN, LUAC_CHECK, str(PANEL)],
                           capture_output=True, text=True, timeout=180)
        self.assertEqual(p.returncode, 0, p.stdout + p.stderr)
        self.assertIn("SYNTAX_OK", p.stdout + p.stderr)

    def test_module_returns_html(self):
        self.assertIn("<!doctype html>", self.lua)
        self.assertIn("M.HTML", self.lua)
        self.assertIn("return M", self.lua)

    def test_js_syntax_in_node(self):
        result = parse_result(run_node(self.js, r"""
          let ok = true, err = '';
          try { new Function(PANEL_JS); } catch(e) { ok = false; err = String(e); }
          console.log(JSON.stringify({ok:ok, err:err}));
        """))
        self.assertTrue(result["ok"], result["err"])

    def test_strict_dom_ids(self):
        # No fabricated IDs: the hand-maintained set must exactly match HTML.
        self.assertEqual(self.html_ids, VALID_IDS,
                         "HTML ids differ from VALID_IDS: missing=%s extra=%s"
                         % (sorted(VALID_IDS - self.html_ids), sorted(self.html_ids - VALID_IDS)))
        # Every $('x') reference must be a declared id.
        self.assertFalse(self.js_ids - VALID_IDS,
                         "undeclared ids used by JS: %s" % sorted(self.js_ids - VALID_IDS))

    def test_existing_broadcast_controls_preserved(self):
        for snippet in ["cmd('arm')", "cmd('start')", "cmd('stop')", "cmd('next')",
                        "cmd('queue_clear')", "cmd('queue'", "enqueue()", "undo()",
                        "toggleRehearsal()", "trigger(sid.value)", "cmd('select',pname.value)",
                        "followTyped()", "id=\"pname_text\"",
                        "obsConnect()", "obsDisc()", "obsRec(true)", "obsRec(false)",
                        "obsScenes()", "obsSetScene()", "obsShot()", "id=\"qat\"",
                        "A arm · S start · X stop · 1-9 trigger shot · N next cue · Z last-shot undo · R rehearsal toggle"]:
            with self.subTest(snippet=snippet):
                self.assertIn(snippet, self.html)
        for snippet in ["setTimeout(poll,700)", "'x-racecam-token'", "DEGRADED", "TARGET LOST",
                        "keydown", "e.key.toLowerCase()", "/^[1-9]$/", "shotHist", "cueList",
                        "op===0", "m.op===2", "op:1", "op:6", "authentication", "sha256b64",
                        "GetSceneList", "GetSceneItemList", "SetCurrentProgramScene",
                        "GetSourceScreenshot", "StartRecord", "StopRecord", "127.0.0.1:4455"]:
            with self.subTest(js=snippet):
                self.assertIn(snippet, self.js)

    def test_new_cards_present(self):
        for snippet in ["Track Loader &amp; Live Event", "/api/live_events", "is_member",
                        "/api/auto_flags", "Auto-Start on Green Light", "Follow Race Leader",
                        "/api/plans", "/api/plan", "routePlanner", "track_canvas",
                        "Remember OBS password on this PC", "Check OBS", "autoload", "rc_tok"]:
            with self.subTest(snippet=snippet):
                self.assertIn(snippet, self.lua)


class BootHashTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.js = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S).group(1)

    def test_token_hash_autoload(self):
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          await sleep(40);
          console.log(JSON.stringify({
            ls: localStorage.getItem('rc_tok'),
            tok: document.getElementById('tok').value,
            replace: replaceStateCalls,
            autoload: globalThis.__rcAutoload === true,
            liveFetched: fetchLog.some(x => x.url === '/api/live_events'),
            liveText: document.getElementById('live_current').textContent,
            trackInfo: document.getElementById('track_info').textContent,
            header: (fetchLog.find(x => x.url === '/api/state') || {opts:{}}).opts.headers
          }));
        """, extra="globalThis.location.hash = '#token=deadbeef&autoload=current';"))
        self.assertEqual(result["ls"], "deadbeef")
        self.assertEqual(result["tok"], "deadbeef")
        self.assertEqual(result["replace"], [[None, "", "/"]])
        self.assertTrue(result["autoload"], "loadCurrentLiveEvent() was not called")
        self.assertTrue(result["liveFetched"])
        self.assertIn("Current Event: Current Trial", result["liveText"])
        self.assertEqual(result["header"], {"x-racecam-token": "deadbeef"})

    def test_tokenless_hash_does_not_replace_url(self):
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          await sleep(20);
          console.log(JSON.stringify({replace:replaceStateCalls,
            ls:localStorage.getItem('rc_tok'), autoload:globalThis.__rcAutoload === true}));
        """, extra="globalThis.location.hash = '#autoload=current';"))
        self.assertEqual(result["replace"], [])
        self.assertIsNone(result["ls"])
        self.assertFalse(result["autoload"])

    def test_sha256_auth_chain_preserved(self):
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          const p = globalThis.racecamPanel;
          console.log(JSON.stringify({
            abc: p.sha256('abc'),
            chain: p.sha256b64(p.sha256b64(pw + salt) + challenge)
          }));
        """, extra="const pw='secret', salt='SALT', challenge='CHALLENGE';"))
        self.assertEqual(result["abc"],
                         "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
        self.assertTrue(result["chain"])

    def test_obs_remember_opt_in(self):
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          const el = document.getElementById('obs_remember');
          document.getElementById('obspw').value = 'hunter2';
          el.checked = true;
          el._ev.change();
          const saved = localStorage.getItem('rc_obs_pw');
          el.checked = false;
          el._ev.change();
          console.log(JSON.stringify({saved:saved,
            cleared:localStorage.getItem('rc_obs_pw'),
            flag:localStorage.getItem('rc_obs_pw_saved')}));
        """))
        self.assertEqual(result["saved"], "hunter2")
        self.assertIsNone(result["cleared"])
        self.assertIsNone(result["flag"])


class RoutePlannerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.js = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S).group(1)
        cls.docs = [as_doc(*shape()) for shape in SHAPES]

    def _node_scripts(self):
        result = parse_result(run_node(self.js, r"""
          const rp = globalThis.routePlanner;
          const out = PAYLOADS.map(doc => {
            const p = rp.parseRoute(doc);
            return {parsed:p,
                    script:rp.buildShots(p.name, p.points, p.gates, {tracksideStride:'auto'}),
                    route:rp.fallbackRouteExport(p.points)};
          });
          console.log(JSON.stringify(out));
        """, extra="(new Function(PANEL_JS))();\nconst PAYLOADS = " + json.dumps(self.docs) + ";"))
        return result

    def assert_json_close(self, a, b, tol=1e-3, path=""):
        if isinstance(a, dict):
            self.assertEqual(set(a), set(b), "keys at %s: %s vs %s" % (path, sorted(a), sorted(b)))
            for k in a:
                self.assert_json_close(a[k], b[k], tol, path + "." + k)
        elif isinstance(a, list):
            self.assertEqual(len(a), len(b), "length at %s" % path)
            for i, (x, y) in enumerate(zip(a, b)):
                self.assert_json_close(x, y, tol, "%s[%d]" % (path, i))
        elif isinstance(a, (int, float)) and not isinstance(a, bool):
            self.assertAlmostEqual(float(a), float(b), delta=tol,
                                   msg="%s: %r vs %r" % (path, a, b))
        else:
            self.assertEqual(a, b, "value at %s" % path)

    def test_build_shots_parity_three_shapes(self):
        node = self._node_scripts()
        self.assertEqual(len(node), len(SHAPES))
        for (name, pts, gates), got in zip((s() for s in SHAPES), node):
            with self.subTest(shape=name):
                want = rp_py.build_shots(name, pts, gates, trackside_stride="auto")
                self.assertEqual([s["id"] for s in got["script"]["shots"]][:9], UNIVERSAL)
                self.assert_json_close(want, got["script"], tol=1e-3)
                want_route = rp_py.fallback_route_export(pts)
                self.assert_json_close(want_route, got["route"], tol=1e-3)

    def test_corner_cameras_and_closed_loop_flags(self):
        node = self._node_scripts()
        for got in node:
            corners = [s for s in got["script"]["shots"] if s.get("role") == "trackside"]
            self.assertTrue(corners, "no corner cameras for " + got["parsed"]["name"])
            for s in corners:
                self.assertEqual(s["kind"], "trackside_pan")
                self.assertTrue(s["auto_zoom"])
                self.assertEqual(s["fov_min"], 28.0)
                self.assertEqual(s["fov_max"], 65.0)
                self.assertRegex(s["id"], r"^corner_\d+_pan$")
            self.assertEqual(got["script"]["source"]["closed_loop"], got["route"]["closed_loop"])

    def test_build_shots_parity_real_fixtures(self):
        names = ["aewol-rally-route.json", "quarry-route.json", "duro290-route.json"]
        docs = [json.loads((REFPY / "fixtures" / n).read_text(encoding="utf-8")) for n in names]
        got = parse_result(run_node(self.js, r"""
          const rp = globalThis.routePlanner;
          console.log(JSON.stringify(PAYLOADS.map(doc => {
            const p = rp.parseRoute(doc);
            return {script:rp.buildShots(p.name, p.points, p.gates, {tracksideStride:'auto'}),
                    route:rp.fallbackRouteExport(p.points)};
          })));
        """, extra="(new Function(PANEL_JS))();\nconst PAYLOADS = " + json.dumps(docs) + ";"))
        for fixture, actual in zip(names, got):
            with self.subTest(fixture=fixture):
                name, pts, gates = rp_py.parse_route(json.loads(
                    (REFPY / "fixtures" / fixture).read_text(encoding="utf-8")))
                self.assert_json_close(rp_py.build_shots(name, pts, gates, trackside_stride="auto"),
                                       actual["script"], tol=1e-9)
                self.assert_json_close(rp_py.fallback_route_export(pts), actual["route"], tol=1e-9)

    def test_parse_route_input_shapes(self):
        docs = [
            {"config": {"Route": {"RouteName": "A", "Waypoints": [
                {"Location": {"X": 1, "Y": 2, "Z": 3}, "Scale3D": {"Y": 20}},
                {"Location": {"X": 11, "Y": 12, "Z": 13}, "Scale3D": {"Y": 20}}]}}},
            {"routeName": "B", "waypoints": [
                {"translation": {"x": 4, "y": 5, "z": 6}, "scale3D": {"y": 21}},
                {"translation": {"x": 14, "y": 15, "z": 16}, "scale3D": {"y": 21}}]},
            {"name": "C", "waypoints": [
                {"x": 7, "y": 8, "z": 9, "gate_m": 22},
                {"x": 17, "y": 18, "z": 19, "gate_m": 22}]},
        ]
        result = parse_result(run_node(self.js, r"""
          const rp = globalThis.routePlanner;
          console.log(JSON.stringify(DOCS.map(d => {
            const p = rp.parseRoute(d);
            return {name:p.name, points:p.points, gates:p.gates,
                    shots:rp.buildShots(p.name, p.points, p.gates).shots.length};
          })));
        """, extra="(new Function(PANEL_JS))();\nconst DOCS = " + json.dumps(docs) + ";"))
        self.assertEqual([r["points"] for r in result],
                         [[[1, 2, 3], [11, 12, 13]], [[4, 5, 6], [14, 15, 16]],
                          [[7, 8, 9], [17, 18, 19]]])
        self.assertEqual([r["gates"] for r in result], [[20, 20], [21, 21], [22, 22]])
        self.assertEqual([r["name"] for r in result], ["A", "B", "C"])


class UniversalInputTests(unittest.TestCase):
    """Universal normalizer + non-/setup_event UX (Task 1-3)."""
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.js = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S).group(1)

    def _normalize(self, raws):
        body = r"""
          const rp = globalThis.routePlanner;
          const out = RAWS.map(r => {
            try {
              const res = rp.parseAnyInput(r.text, r.hint || 'test.json');
              return {ok:true, mode:res.mode, plan_id:res.plan_id,
                name: res.parsed ? res.parsed.name : ((res.plan && res.plan.name) || null),
                points: res.parsed ? res.parsed.points : null,
                gates: res.parsed ? res.parsed.gates : null,
                shotIds: (res.plan && Array.isArray(res.plan.shots)) ? res.plan.shots.map(s=>s.id) : [],
                routeOk: !!res.route,
                routePassthrough: !!(res.route && res.route.samples)};
            } catch(e) { return {ok:false, error:String(e)}; }
          });
          console.log(JSON.stringify(out));
        """
        return parse_result(run_node(
            self.js, body,
            extra="(new Function(PANEL_JS))();\nconst RAWS = " + json.dumps(raws) + ";"))

    def test_new_universal_ui_present(self):
        for snippet in ["id=\"track_loader_card\"", "Auto-apply on drop", "Paste JSON",
                        "Parse &amp; Preview", "Dropped Files (racecam/inbox/)",
                        "Load Dropped File", "Standalone / File Mode",
                        "Requires active in-game event", "Pin Position", "Undo Pin",
                        "Clear Pins", "0 pins", "Build &amp; Load Pins",
                        "/api/inbox", "/api/inbox_file", "/api/my_pos",
                        "parseAnyInput", "parsePasted", "refreshInbox", "buildPins"]:
            with self.subTest(snippet=snippet):
                self.assertIn(snippet, self.lua)

    def test_parse_any_input_all_six_shapes(self):
        event_to_table = {
            "EventName": "Jeju Circuit Sprint",
            "RaceSetup": {"Route": {"RouteName": "Jeju Circuit", "Waypoints": [
                {"Translation": {"X": 0, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
                {"Translation": {"X": 4000, "Y": 0, "Z": 50}, "Scale3D": {"Y": 18}},
                {"Translation": {"X": 8000, "Y": 3000, "Z": 100}, "Scale3D": {"Y": 18}},
            ]}}
        }
        snake_case = {
            "name": "AMC Drift Meet",
            "race_setup": {"route": {"route_name": "Harbor Drift", "waypoints": [
                {"translation": {"x": 10, "y": 20, "z": 30}, "scale3d": {"y": 22}},
                {"translation": {"x": 110, "y": 220, "z": 330}, "scale3d": {"y": 22}},
                {"translation": {"x": 210, "y": 320, "z": 430}, "scale3d": {"y": 22}},
            ]}}
        }
        track_editor = {
            "config": {"Route": {"RouteName": "Quarry Hill", "Waypoints": [
                {"Location": {"X": 1, "Y": 2, "Z": 3}, "Scale3D": {"Y": 20}},
                {"Location": {"X": 11, "Y": 12, "Z": 13}, "Scale3D": {"Y": 20}},
                {"Location": {"X": 21, "Y": 22, "Z": 23}, "Scale3D": {"Y": 20}},
            ]}}
        }
        bare = [{"X": 100, "Y": 200, "Z": 300},
                {"x": 400, "y": 500, "z": 600, "gate_m": 25},
                [700, 800, 900]]
        prebuilt = {
            "plan_id": "hand tuned!",
            "shots": [{"id": "start_line", "kind": "look_at", "location": [1, 2, 3],
                       "look_at": [4, 5, 6], "fov": 55}],
            "route": {"samples": [{"x": 0, "y": 0, "z": 0}], "closed_loop": False},
        }
        discord = {"RouteName": "Discord Rally", "Waypoints": [
            {"Location": {"X": 5, "Y": 6, "Z": 7}, "Scale3D": {"Y": 19}},
            {"Location": {"X": 105, "Y": 106, "Z": 107}, "Scale3D": {"Y": 19}},
            {"Location": {"X": 205, "Y": 206, "Z": 207}, "Scale3D": {"Y": 19}},
        ]}
        raws = [
            {"text": json.dumps(event_to_table), "hint": "event_to_table.json"},
            {"text": json.dumps(snake_case), "hint": "scheduled_event.json"},
            {"text": json.dumps(track_editor), "hint": "track_editor.json"},
            {"text": json.dumps(bare), "hint": "bare_waypoints.json"},
            {"text": json.dumps(prebuilt), "hint": "plan.json"},
            {"text": "```json\n" + json.dumps(discord) + "\n```", "hint": "discord.txt"},
        ]
        got = self._normalize(raws)
        self.assertEqual(len(got), 6)
        for res in got:
            self.assertTrue(res["ok"], res.get("error"))

        # 1. full Motor Town EventToTable
        self.assertEqual(got[0]["mode"], "route")
        self.assertEqual(got[0]["name"], "Jeju Circuit Sprint")
        self.assertEqual(got[0]["points"], [[0, 0, 0], [4000, 0, 50], [8000, 3000, 100]])
        self.assertEqual(got[0]["gates"], [18, 18, 18])
        # 2. AMC snake_case race_setup (lowercase scale3d)
        self.assertEqual(got[1]["mode"], "route")
        self.assertEqual(got[1]["name"], "AMC Drift Meet")
        self.assertEqual(got[1]["gates"], [22, 22, 22])
        # 3. Track Editor / config.Route
        self.assertEqual(got[2]["mode"], "route")
        self.assertEqual(got[2]["name"], "Quarry Hill")
        self.assertEqual(got[2]["gates"], [20, 20, 20])
        # 4. bare waypoints incl. PascalCase object + numeric tuple
        self.assertEqual(got[3]["mode"], "route")
        self.assertEqual(got[3]["points"], [[100, 200, 300], [400, 500, 600], [700, 800, 900]])
        self.assertEqual(got[3]["gates"], [18, 25, 18])
        self.assertEqual(got[3]["plan_id"], "bare_waypoints")
        self.assertEqual([self._normalize([{"text": json.dumps(bare), "hint": h}])[0]["plan_id"]
                          for h in ("aewol-rally-route.json", "aewol-rally-route.TXT")],
                         ["aewol-rally-route", "aewol-rally-route"])
        # 5. pre-built plan passthrough (no regeneration, custom shots preserved)
        self.assertEqual(got[4]["mode"], "prebuilt_plan")
        self.assertEqual(got[4]["plan_id"], "hand_tuned")
        self.assertEqual(got[4]["shotIds"], ["start_line"])
        self.assertTrue(got[4]["routePassthrough"])
        # 6. Discord ```json fenced paste
        self.assertEqual(got[5]["mode"], "route")
        self.assertEqual(got[5]["name"], "Discord Rally")
        self.assertEqual(got[5]["points"], [[5, 6, 7], [105, 106, 107], [205, 206, 207]])

        for res in got[:4] + [got[5]]:
            with self.subTest(plan_id=res["plan_id"]):
                self.assertEqual(res["shotIds"][:9], UNIVERSAL)
                self.assertEqual(res["shotIds"][0], "start_line")
                self.assertTrue(res["routeOk"])
                self.assertIn("finish_line", res["shotIds"])
                self.assertIn("route_flyover", res["shotIds"])
                self.assertTrue(any(i.startswith("corner_") for i in res["shotIds"]))

    def test_standalone_badge_disables_auto_flags(self):
        result = parse_result(run_node(self.js, r"""
          await sleep(30);
          const badge = document.getElementById('standalone_badge');
          const liveState = {display:badge.style.display,
            disabled:document.getElementById('auto_start').disabled};
          globalThis.__noLiveEvents = true;
          await globalThis.racecamPanel.refreshLiveEvents();
          const alone = {display:badge.style.display, text:badge.textContent,
            disabled:document.getElementById('auto_start').disabled,
            title:document.getElementById('auto_start').title,
            followDisabled:document.getElementById('follow_leader').disabled};
          globalThis.__noLiveEvents = false;
          await globalThis.racecamPanel.refreshLiveEvents();
          const back = {display:badge.style.display,
            disabled:document.getElementById('auto_start').disabled,
            title:document.getElementById('auto_start').title};
          console.log(JSON.stringify({liveState:liveState, alone:alone, back:back}));
        """, extra="(new Function(PANEL_JS))();"))
        self.assertEqual(result["liveState"]["display"], "none")
        self.assertFalse(result["liveState"]["disabled"])
        self.assertEqual(result["alone"]["display"], "inline-block")
        self.assertIn("Standalone / File Mode", result["alone"]["text"])
        self.assertTrue(result["alone"]["disabled"])
        self.assertTrue(result["alone"]["followDisabled"])
        self.assertEqual(result["alone"]["title"], "Requires active in-game event")
        self.assertEqual(result["back"]["display"], "none")
        self.assertFalse(result["back"]["disabled"])
        self.assertEqual(result["back"]["title"], "")

    def test_full_card_drop_and_auto_apply(self):
        doc = {"RouteName": "Dropped Track", "Waypoints": [
            {"Location": {"X": 0, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 3000, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 3000, "Y": 4000, "Z": 0}, "Scale3D": {"Y": 18}},
        ]}
        result = parse_result(run_node(self.js, r"""
          const card = document.getElementById('track_loader_card');
          const file = {name:'dropped.json', _text:JSON.stringify(DOC)};
          const ev = {preventDefault(){}, dataTransfer:{dropEffect:'', files:[file]}};
          card._ev.dragover({preventDefault(){}, dataTransfer:{}});
          const highlighted = card.className;
          card._ev.drop(ev);
          const first = {info:document.getElementById('track_info').textContent,
            cls:card.className, planPosts:fetchLog.filter(x=>x.url==='/api/plan').length};
          document.getElementById('auto_apply').checked = true;
          card._ev.drop(ev);
          await sleep(10);
          const second = {planPosts:fetchLog.filter(x=>x.url==='/api/plan').length,
            info:document.getElementById('track_info').textContent};
          console.log(JSON.stringify({highlighted:highlighted, first:first, second:second}));
        """, extra="(new Function(PANEL_JS))();\nconst DOC = " + json.dumps(doc) + ";"))
        self.assertIn("drop-over", result["highlighted"])
        self.assertIn("3 waypoints", result["first"]["info"])
        self.assertEqual(result["first"]["cls"], "card")
        self.assertEqual(result["first"]["planPosts"], 0)
        self.assertEqual(result["second"]["planPosts"], 1)

    def test_discord_paste_card_handler_and_inbox(self):
        paste_doc = {"RouteName": "Discord Rally", "Waypoints": [
            {"Location": {"X": 0, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 2500, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 2500, "Y": 3500, "Z": 0}, "Scale3D": {"Y": 18}},
        ]}
        inbox_doc = {"RaceSetup": {"Route": {"RouteName": "Inbox Event", "Waypoints": [
            {"Translation": {"X": 1, "Y": 2, "Z": 3}, "Scale3D": {"Y": 18}},
            {"Translation": {"X": 1001, "Y": 2, "Z": 3}, "Scale3D": {"Y": 18}},
            {"Translation": {"X": 2001, "Y": 2, "Z": 3}, "Scale3D": {"Y": 18}},
        ]}}}
        result = parse_result(run_node(self.js, r"""
          const card = document.getElementById('track_loader_card');
          const fenced = '```json\n' + JSON.stringify(PASTE_DOC) + '\n```';
          card._ev.paste({preventDefault(){}, clipboardData:{getData(){return fenced}}});
          const pastedValue = document.getElementById('paste_json').value;
          await globalThis.racecamPanel.parsePasted();
          const pastedInfo = document.getElementById('track_info').textContent;
          const names = await globalThis.racecamPanel.refreshInbox();
          const sel = document.getElementById('inbox_files');
          const opts = sel.options.map(o=>o.value);
          sel.value = 'drop_event.json';
          globalThis.__inboxContent = JSON.stringify(INBOX_DOC);
          await globalThis.racecamPanel.loadInboxFile();
          const inboxFetch = fetchLog.filter(x=>x.url && x.url.indexOf('/api/inbox_file?')===0).pop();
          console.log(JSON.stringify({pastedValue:pastedValue, pastedInfo:pastedInfo,
            names:names, opts:opts, inboxUrl:inboxFetch && inboxFetch.url,
            inboxInfo:document.getElementById('track_info').textContent}));
        """, extra=("(new Function(PANEL_JS))();\nconst PASTE_DOC = "
                    + json.dumps(paste_doc) + ";\nconst INBOX_DOC = " + json.dumps(inbox_doc) + ";")))
        self.assertTrue(result["pastedValue"].startswith("```json"))
        self.assertIn("Discord Rally", result["pastedInfo"])
        self.assertEqual(result["names"], ["drop_event.json", "event.json", "route.txt"])
        self.assertEqual(result["opts"], ["drop_event.json", "event.json", "route.txt"])
        self.assertEqual(result["inboxUrl"], "/api/inbox_file?name=drop_event.json")
        self.assertIn("Inbox Event", result["inboxInfo"])

    def test_pin_position_builds_valid_shot_deck(self):
        result = parse_result(run_node(self.js, r"""
          const p = globalThis.racecamPanel;
          await p.pinPosition(); await p.pinPosition(); await p.pinPosition();
          const count = document.getElementById('pin_count').textContent;
          const enabled = !document.getElementById('pin_build').disabled;
          const posCalls = fetchLog.filter(x=>x.url==='/api/my_pos').length;
          await p.buildPins();
          await sleep(10);
          const planCall = fetchLog.filter(x=>x.url==='/api/plan').pop();
          const body = JSON.parse(planCall.opts.body);
          const ids = body.plan.shots.map(s=>s.id);
          const before = fetchLog.filter(x=>x.url==='/api/plan').length;
          await p.clearPins(); await p.pinPosition(); await p.pinPosition(); await p.buildPins();
          const after = fetchLog.filter(x=>x.url==='/api/plan').length;
          console.log(JSON.stringify({count:count, enabled:enabled, posCalls:posCalls,
            plan_id:body.plan_id, shotCount:ids.length, routeOk:!!body.route,
            hasCore:['start_line','finish_line','route_flyover'].every(x=>ids.indexOf(x)>=0),
            corners:ids.filter(x=>/^corner_\d+_pan$/.test(x)).length,
            before:before, after:after}));
        """, extra="(new Function(PANEL_JS))();"))
        self.assertEqual(result["count"], "3 pins")
        self.assertTrue(result["enabled"])
        self.assertEqual(result["posCalls"], 3)
        self.assertEqual(result["plan_id"], "free_roam")
        self.assertTrue(result["hasCore"])
        self.assertGreater(result["corners"], 0)
        self.assertGreaterEqual(result["shotCount"], 11)
        self.assertTrue(result["routeOk"])
        self.assertEqual(result["after"], result["before"],
                         "buildPins must not post with fewer than 3 pins")


if __name__ == "__main__":
    unittest.main()
