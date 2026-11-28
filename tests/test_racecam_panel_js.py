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
import math
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
    "queue", "qat", "sid", "tgt_name", "standings_hdr", "contestants",
    "sm_tight", "sm_normal", "sm_cinematic",
    "live_current", "live_load_btn", "live_refresh", "live_events", "auto_start",
    "follow_leader", "track_file", "drop_zone", "saved_plans", "plans_refresh",
    "plan_load", "track_info", "track_canvas",
    "track_loader_card", "auto_apply", "paste_json", "paste_preview",
    "inbox_files", "inbox_load", "inbox_refresh", "standalone_badge",
    "pin_position", "pin_undo", "pin_clear", "pin_count", "pin_build",
    "obsurl", "obspw", "obsst", "obs_check", "obs_remember", "obsscene", "obssrc",
    "obsprev", "out", "panel_manual",
    # Broadcast Desk v2 — sticky tally bar
    "tally_bar", "arm_pill", "pgm", "keys_pill", "auth_pill", "obs_pill",
    "reh_btn", "stop_btn", "reh", "deg", "toast", "footer_bar",
    # Broadcast Desk v2 — two-column desk
    "desk", "transport_card", "mode_btn", "take_btn",
    "pad_card", "shot_pads", "shot_pads_extra",
    "cue_card", "q", "obs_quick", "rec_btn", "rec_time", "obs_scene_pads",
    "field_card", "auto_follow", "preview_card", "pv_canvas", "pv_meta",
    # Broadcast Desk v2 — collapsible drawers + aliased OBS fields
    "drawer_setup", "drawer_conn", "drawer_log",
    "obs_url", "obs_pw", "obs_rem", "obs_sc",
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
    configurable: true,
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
  if (url === '/api/state') j = globalThis.__stateOverride || {degraded:false, target_lost:false, shots:['start_line','corner_01_pan'],
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
                        "toggleRehearsal()", "trigger(sid.value)",
                        "lockTyped()", "id=\"tgt_name\"", "id=\"standings_hdr\"",
                        "id=\"contestants\"", "setTargetByName(name)",
                        "obsConnect()", "obsDisc()", "obsRec(true)", "obsRec(false)",
                        "obsScenes()", "obsSetScene()", "obsShot()", "id=\"qat\"",
                        "A arm · S start · X stop · 1-9 trigger shot · Alt+1-9 target contestant"]:
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

    def test_operator_guide_at_bottom_of_panel(self):
        """A collapsible, drive-letter-free operator guide teaches every section."""
        m = re.search(r'<details id="panel_manual" class="card">([\s\S]*?)</details>', self.lua)
        assert m is not None, "missing <details id=\"panel_manual\" class=\"card\">"
        guide = m.group(0)
        script_at = self.lua.index("<script>")
        self.assertLess(m.start(), script_at, "guide must be inside the page, not in JS")
        self.assertEqual(self.lua[m.end():script_at].strip(), "",
                         "guide must be the last HTML block, below all control cards")
        self.assertIn("<summary><strong>Operator Guide — How to Use This Panel</strong> "
                      "(click to expand)</summary>", guide)

        teaching_points = [
            # 1. Quick Start
            "1. Quick Start (4 steps)", "Ctrl+Shift+F10", "Load Current Event &amp; Open Panel",
            "standby", "Quick Follow", "&lt; 1 s",
            # 2. Loading any track
            "2. Loading Any Track — 4 ways, zero Python", "Live In-Game Event",
            "/setup_event", "native Motor Town events", "Upload / Drop / Paste JSON",
            "Auto-apply on drop", "```json", "racecam/inbox/", "drop_event.json",
            "race_setup", "bare waypoint arrays", "{ shots: [...] }",
            "Free-Roam Pin Position", "Pin Position", "Build &amp; Load Pins",
            "Quick Follow (No Track)", "car-relative",
            # 3. Shot deck
            "3. Universal", "Shot Deck", "extra (<code>·</code>) shots", "finish_line",
            "overview", "corner_XX_pan",
            # 4. Hotkeys
            "4. Keyboard Hotkeys", "focus is outside text inputs",
            "<code>A</code> Arm", "<code>S</code> Start Race", "Camera Slots",
            "<code>Alt+1</code>–<code>Alt+9</code> Switch Contestant",
            "<code>Q</code> Queue shot", "<code>N</code> Fire next queued cue",
            "<code>Z</code> Clear queue", "<code>R</code> Toggle Rehearsal",
            "<code>X</code> Panic Stop",
            # 5. Contestants, automation, safety, OBS
            "5. Contestants, Automation, Safety/Fail-Safes &amp; OBS",
            "P1</code>/<code>P2</code>/<code>P3", "● ON AIR", "Follow Race Leader",
            "Auto-Start on Green Light", "TARGET LOST", "Rehearsal",
            "Start record", "Stop record", "120 s", "DEGRADED",
            "127.0.0.1:4455", "Check OBS", "Studio Mode",
        ]
        for snippet in teaching_points:
            with self.subTest(teaching=snippet):
                self.assertIn(snippet, guide)
        for shot in UNIVERSAL:
            with self.subTest(shot=shot):
                self.assertIn("<code>%s</code>" % shot, guide)

        # No Windows drive-letter paths, and no new JS DOM lookups in the guide.
        self.assertNotIn("D:", guide)
        self.assertIsNone(re.search(r"\b[A-Z]:[\\/]", guide))
        self.assertNotIn("$('", guide)


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

    @staticmethod
    def core_projection(plan):
        """Fields still byte-identical to the unchanged Python reference:
        metadata plus the original 11 shots (slots 1-9, finish_line, overview).
        The v2 planner deliberately adds broadcast rigs, specialty cameras and
        outside-apex corners; those are covered by dedicated tests below. The
        Python reference in amc-racecam is intentionally left untouched here
        (out of this worktree's file ownership).
        """
        return {"schema": plan["schema"], "name": plan["name"],
                "source": plan["source"], "units": plan["units"],
                "shots": plan["shots"][:11]}

    @staticmethod
    def corner_ids(plan):
        return [s["id"] for s in plan["shots"]
                if re.match(r"^corner_\d+_pan$", s.get("id", ""))]

    def test_build_shots_parity_three_shapes(self):
        node = self._node_scripts()
        self.assertEqual(len(node), len(SHAPES))
        for (name, pts, gates), got in zip((s() for s in SHAPES), node):
            with self.subTest(shape=name):
                want = rp_py.build_shots(name, pts, gates, trackside_stride="auto")
                self.assertEqual([s["id"] for s in got["script"]["shots"]][:9], UNIVERSAL)
                self.assert_json_close(self.core_projection(want),
                                       self.core_projection(got["script"]), tol=1e-3)
                self.assertEqual(self.corner_ids(want), self.corner_ids(got["script"]),
                                 "corner selection must stay in parity with the Python planner")
                want_route = rp_py.fallback_route_export(pts)
                self.assert_json_close(want_route, got["route"], tol=1e-3)

    def test_corner_cameras_and_closed_loop_flags(self):
        node = self._node_scripts()
        for got in node:
            corners = [s for s in got["script"]["shots"]
                       if re.match(r"^corner_\d+_pan$", s.get("id", ""))]
            self.assertTrue(corners, "no corner cameras for " + got["parsed"]["name"])
            for s in corners:
                self.assertEqual(s["kind"], "trackside_pan")
                self.assertEqual(s["role"], "trackside")
                self.assertTrue(s["auto_zoom"])
                self.assertEqual(s["fov"], 45.0)
                self.assertEqual(s["fov_min"], 13.0)
                self.assertEqual(s["fov_max"], 58.0)
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
                self.assert_json_close(self.core_projection(rp_py.build_shots(
                                           name, pts, gates, trackside_stride="auto")),
                                       self.core_projection(actual["script"]), tol=1e-9)
                self.assertEqual(self.corner_ids(rp_py.build_shots(
                                     name, pts, gates, trackside_stride="auto")),
                                 self.corner_ids(actual["script"]))
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


class LiveLeaderboardTests(unittest.TestCase):
    """Task 2: 1-click contestant deck, Alt+1..9 hotkeys, click-safe DOM diff."""
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        m = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S)
        assert m, "no <script> block in panel_ui.lua"
        cls.js = m.group(1)

    @staticmethod
    def event_state():
        return {
            "standings": {
                "event_name": "Aewol Sprint", "state": 2, "in_countdown": False,
                "num_laps": 5, "waypoint_count": 12,
                "standings": [
                    {"rank": 1, "name": "Alice", "laps": 2, "section": 7,
                     "best_lap_s": 84.3, "last_sec_s": 120.0,
                     "finished": False, "disqualified": False},
                    {"rank": 2, "name": "Bob", "laps": 2, "section": 7,
                     "best_lap_s": 88.0, "last_sec_s": 121.4,
                     "finished": False, "disqualified": False},
                    {"rank": 3, "name": "Cara", "laps": 5, "section": 12,
                     "best_lap_s": 82.0, "last_sec_s": 600.0,
                     "finished": True, "disqualified": False},
                    {"rank": 0, "name": "Dex", "laps": 0, "section": 0,
                     "best_lap_s": 0, "last_sec_s": 0,
                     "finished": False, "disqualified": True},
                ],
            },
            "target_name": "Alice",
            "targets": ["Alice", "Bob", "Cara", "Dex"],
        }

    def test_dropdown_replaced_by_button_deck(self):
        for gone in ['<select id="tgt"', '<select id="pname"', 'id="pname_text"',
                     "cmd('select',pname.value)", "followTyped()"]:
            with self.subTest(gone=gone):
                self.assertNotIn(gone, self.lua)
        for want in ['<div id="standings_hdr" class="kbd">',
                     '<div id="contestants" class="roster">',
                     '<input id="tgt_name"', 'onclick="lockTyped()"',
                     'data-rc-target', "Alt+1-9 target contestant", "/api/target",
                     "renderContestants", "lastRosterSig"]:
            with self.subTest(want=want):
                self.assertIn(want, self.lua)

    def test_event_mode_rankings_gaps_highlight_and_click(self):
        state = self.event_state()
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          const p = globalThis.racecamPanel;
          p.renderContestants(EVENT);
          document.getElementById('follow_leader').checked = true;
          const el = document.getElementById('contestants');
          const html = el.innerHTML, hdr = document.getElementById('standings_hdr').innerHTML;
          el._ev.click({target:{closest:()=>({getAttribute:()=> 'Bob'})}});
          await sleep(20);
          console.log(JSON.stringify({
            hdr: hdr, html: html, names: p.getRosterNames(),
            targets: fetchLog.filter(x=>x.url==='/api/target').map(x=>JSON.parse(x.opts.body)),
            autoFlags: fetchLog.filter(x=>x.url==='/api/auto_flags').map(x=>JSON.parse(x.opts.body)),
            followChecked: document.getElementById('follow_leader').checked
          }));
        """, extra=("globalThis.__stateOverride = " + json.dumps(state) + ";\n"
                    "const EVENT = " + json.dumps(state) + ";")))
        html = result["html"]
        self.assertEqual(result["names"], ["Alice", "Bob", "Cara", "Dex"])
        self.assertEqual(html.count("<button"), 4)
        self.assertNotIn("<select", html)
        # Rank badges: gold / silver / bronze ordering, DQ muted.
        self.assertIn('<span class="rc-pos p1">P1</span>', html)
        self.assertIn('<span class="rc-pos p2">P2</span>', html)
        self.assertIn('<span class="rc-pos dq">DQ</span>', html)
        # Header: event, lap count, live status pill.
        self.assertIn("Aewol Sprint · Laps: 5", result["hdr"])
        self.assertIn(">RACING</span>", result["hdr"])
        # Telemetry: lap/gate, m:ss.t best lap, same-lap/gate +delta gap, FIN / DQ.
        self.assertIn("L2/5 · G7/12 · 1:24.3", html)
        self.assertIn("L2/5 · G7/12 · 1:28.0 · +1.4s", html)
        self.assertIn("FIN · 1:22.0", html)
        self.assertIn('<span class="rc-tele">DQ</span>', html)
        # Active target: bright green border + ON AIR pill, exactly once.
        self.assertIn('class="rc-driver onair" data-rc-target="Alice"', html)
        self.assertEqual(html.count("● ON AIR"), 1)
        # Click cuts the target via POST /api/target and hands off follow_leader.
        self.assertIn({"name": "Bob"}, result["targets"])
        self.assertFalse(result["followChecked"])
        self.assertTrue(any(f.get("follow_leader") is False
                            for f in result["autoFlags"]))

    def test_event_best_lap_formats_minutes_and_seconds(self):
        state = self.event_state()
        state["standings"]["standings"][0]["best_lap_s"] = 64.3
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          globalThis.racecamPanel.renderContestants(EVENT);
          console.log(JSON.stringify({html:document.getElementById('contestants').innerHTML}));
        """, extra="const EVENT = " + json.dumps(state) + ";"))
        self.assertIn("L2/5 · G7/12 · 1:04.3", result["html"])

    def test_point_to_point_omits_lap_progress(self):
        state = self.event_state()
        state["standings"]["num_laps"] = 0
        state["standings"]["in_countdown"] = True
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          globalThis.racecamPanel.renderContestants(EVENT);
          console.log(JSON.stringify({hdr:document.getElementById('standings_hdr').innerHTML,
                                      html:document.getElementById('contestants').innerHTML}));
        """, extra="const EVENT = " + json.dumps(state) + ";"))
        self.assertIn("Point-to-Point", result["hdr"])
        self.assertIn(">COUNTDOWN</span>", result["hdr"])
        self.assertIn('<span class="rc-tele">G7/12 · 1:24.3</span>', result["html"])

    def test_standalone_mode_renders_one_click_vehicle_buttons(self):
        state = {"standings": None, "targets": ["Zoe", "Yan"], "target_name": "Yan"}
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          const p = globalThis.racecamPanel;
          p.renderContestants(EVENT);
          const el = document.getElementById('contestants');
          const withVehicles = {hdr:document.getElementById('standings_hdr').innerHTML,
            cls:el.className, html:el.innerHTML, names:p.getRosterNames()};
          p.renderContestants({standings:null, targets:[], target_name:''});
          const empty = {hdr:document.getElementById('standings_hdr').innerHTML,
            html:document.getElementById('contestants').innerHTML};
          console.log(JSON.stringify({withVehicles:withVehicles, empty:empty}));
        """, extra="const EVENT = " + json.dumps(state) + ";")) 
        deck = result["withVehicles"]
        self.assertEqual(deck["hdr"], "Live Vehicles (click to target)")
        self.assertEqual(deck["cls"], "roster standalone")
        self.assertEqual(deck["names"], ["Zoe", "Yan"])
        self.assertEqual(deck["html"].count("<button"), 2)
        self.assertNotIn("<select", deck["html"])
        self.assertIn('class="rc-driver onair" data-rc-target="Yan"', deck["html"])
        self.assertEqual(deck["html"].count("● ON AIR"), 1)
        self.assertEqual(result["empty"]["hdr"], "No vehicles detected")
        self.assertEqual(result["empty"]["html"], "")

    def test_alt_hotkeys_target_without_firing_camera_slots(self):
        state = self.event_state()
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          await sleep(20);   // let boot's initial poll settle
          const sid = document.getElementById('sid');
          sid.options.push({value:'start_line'},{value:'corner_01_pan'});
          let prevented = 0;
          const fire = (key, alt) => keyHandler({key:key, altKey:alt, ctrlKey:false,
            metaKey:false, target:{tagName:'DIV'}, preventDefault(){prevented++}});
          fire('1', true); fire('2', true);
          await sleep(20);
          const targets = fetchLog.filter(x=>x.url==='/api/target').map(x=>JSON.parse(x.opts.body));
          const cameraAfterAlt = fetchLog.filter(x=>x.url==='/api/command')
            .map(x=>JSON.parse(x.opts.body));
          fire('1', false);   // plain 1 must still fire the camera slot
          await sleep(20);
          const cameraAfterPlain = fetchLog.filter(x=>x.url==='/api/command')
            .map(x=>JSON.parse(x.opts.body));
          console.log(JSON.stringify({names:globalThis.racecamPanel.getRosterNames(),
            targets:targets, prevented:prevented, cameraAfterAlt:cameraAfterAlt,
            cameraAfterPlain:cameraAfterPlain}));
        """, extra=("let keyHandler=null;\n"
                    "document.addEventListener=(ev,fn)=>{if(ev==='keydown')keyHandler=fn};\n"
                    "globalThis.__stateOverride = " + json.dumps(state) + ";\n")))
        self.assertEqual(result["names"], ["Alice", "Bob", "Cara", "Dex"])
        self.assertEqual(result["targets"], [{"name": "Alice"}, {"name": "Bob"}])
        self.assertEqual(result["prevented"], 2)
        self.assertEqual(result["cameraAfterAlt"], [],
                         "Alt+1/Alt+2 must not trigger 1/2 camera shots")
        self.assertIn({"cmd": "trigger", "args": "start_line"}, result["cameraAfterPlain"])

    def test_identical_state_does_not_rebuild_dom(self):
        state = self.event_state()
        result = parse_result(run_node(self.js, r"""
          (new Function(PANEL_JS))();
          await sleep(20);   // initial standalone poll
          const c=document.getElementById('contestants'), h=document.getElementById('standings_hdr');
          let cWrites=0,hWrites=0;
          Object.defineProperty(c,'innerHTML',{get(){return c._html||''},
            set(v){c._html=v;cWrites++;if(v==='')c.options.length=0}});
          Object.defineProperty(h,'innerHTML',{get(){return h._html||''},
            set(v){h._html=v;hWrites++}});
          const p=globalThis.racecamPanel;
          p.renderContestants(EVENT);
          const sig1=p.getRosterSig(), w1=[cWrites,hWrites];
          p.renderContestants(EVENT_COPY);            // identical values, new object
          const sig2=p.getRosterSig(), w2=[cWrites,hWrites];
          const CHANGED=JSON.parse(JSON.stringify(EVENT));
          CHANGED.standings.standings[1].laps=3;
          p.renderContestants(CHANGED);
          const w3=[cWrites,hWrites];
          console.log(JSON.stringify({sig1:sig1,sig2:sig2,w1:w1,w2:w2,w3:w3}));
        """, extra=("globalThis.__stateOverride = {standings:null, targets:['Driver'], target_name:''};\n"
                    "const EVENT = " + json.dumps(state) + ";\n"
                    "const EVENT_COPY = JSON.parse(JSON.stringify(EVENT));\n")))
        self.assertEqual(result["sig1"], result["sig2"])
        self.assertEqual(result["w1"], [1, 1])
        self.assertEqual(result["w2"], [1, 1],
                         "identical state must not rebuild the contestant DOM")
        self.assertEqual(result["w3"], [2, 2],
                         "a changed row must rebuild exactly once")


class SmoothingControlTests(unittest.TestCase):
    """Operator camera-smoothing toggle: tight | normal | cinematic."""
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.js = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S).group(1)
        cls.handlers = {}
        for mode in ("tight", "normal", "cinematic"):
            m = re.search(r'id="sm_%s"[^>]*onclick="([^"]+)"' % mode, cls.lua)
            assert m, "missing onclick handler for sm_%s" % mode
            cls.handlers[mode] = m.group(1)
        # No Windows drive-letter paths in the panel (Scale3D: is not a path).
        self_free = re.search(r"\bD:[\\/]", cls.lua)
        assert self_free is None, "panel must not use D: paths"

    @staticmethod
    def _state(smoothing=None):
        state = {"degraded": False, "target_lost": False, "shots": ["start_line"],
                 "targets": ["Driver"], "rehearsal": False, "running": False}
        if smoothing is not None:
            state["smoothing"] = smoothing
        return state

    def _click(self, mode):
        """Fire the real inline onclick string from the HTML on a live panel."""
        extra = ("(new Function(PANEL_JS))();\n"
                 "const CLICK = " + json.dumps(self.handlers[mode]) + ";\n")
        result = parse_result(run_node(self.js, r"""
          await sleep(20);                       // let boot's first poll settle
          const p = globalThis.racecamPanel;
          (new Function('setSmoothing', CLICK))(p.setSmoothing);
          await sleep(20);
          const cls = ['tight','normal','cinematic'].map(m =>
            document.getElementById('sm_'+m).className);
          console.log(JSON.stringify({
            posts: fetchLog.filter(x => x.url === '/api/command')
                           .map(x => JSON.parse(x.opts.body)),
            classes: cls, mode: p.getSmoothingMode()
          }));
        """, extra=extra))
        return result

    def test_markup_and_handler_wiring(self):
        for mode in ("tight", "normal", "cinematic"):
            with self.subTest(mode=mode):
                self.assertIn('id="sm_%s"' % mode, self.lua)
                self.assertEqual(self.handlers[mode],
                                 "setSmoothing('%s')" % mode)
        for snippet in ["const SMOOTHING_MODES=['tight','normal','cinematic']",
                        "return cmd('smoothing',mode)", "highlightSmoothing(sMode)",
                        "s.smoothing"]:
            with self.subTest(snippet=snippet):
                self.assertIn(snippet, self.js)

    def test_click_sm_tight_posts_smoothing_command(self):
        result = self._click("tight")
        self.assertIn({"cmd": "smoothing", "args": "tight"}, result["posts"])
        self.assertEqual(result["mode"], "tight")
        self.assertEqual(result["classes"],
                         ["sm-btn on", "sm-btn", "sm-btn"])

    def test_click_sm_cinematic_posts_smoothing_command(self):
        result = self._click("cinematic")
        self.assertIn({"cmd": "smoothing", "args": "cinematic"}, result["posts"])
        self.assertEqual(result["mode"], "cinematic")
        self.assertEqual(result["classes"],
                         ["sm-btn", "sm-btn", "sm-btn on"])

    def test_poll_syncs_highlight_from_state(self):
        extra = ("globalThis.__stateOverride = "
                 + json.dumps(self._state("cinematic")) + ";\n"
                 + "(new Function(PANEL_JS))();\n"
                 + "const NORMAL_STATE = "
                 + json.dumps(self._state("normal")) + ";\n")
        result = parse_result(run_node(self.js, r"""
          await sleep(30);                       // boot's poll has applied
          const p = globalThis.racecamPanel;
          const read = () => ['tight','normal','cinematic'].map(m =>
            document.getElementById('sm_'+m).className);
          const cinematic = {classes:read(), mode:p.getSmoothingMode()};
          globalThis.__stateOverride = NORMAL_STATE;
          await p.poll();
          await sleep(20);
          const normal = {classes:read(), mode:p.getSmoothingMode()};
          console.log(JSON.stringify({cinematic:cinematic, normal:normal}));
        """, extra=extra))
        self.assertEqual(result["cinematic"]["classes"],
                         ["sm-btn", "sm-btn", "sm-btn on"])
        self.assertEqual(result["cinematic"]["mode"], "cinematic")
        self.assertEqual(result["normal"]["classes"],
                         ["sm-btn", "sm-btn on", "sm-btn"])
        self.assertEqual(result["normal"]["mode"], "normal")




class BroadcastDeskTests(unittest.TestCase):
    """Broadcast Desk v2: stream-board layout, camera pads, preview→take, focus UX."""
    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        m = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S)
        assert m, "no <script> block in panel_ui.lua"
        cls.js = m.group(1)
        cls.shots = ["start_line", "fly_up", "auto_trackside", "heli_follow",
                     "follow_focus", "front_chase", "side_tracking", "orbit_hero",
                     "route_flyover", "finish_line", "overview",
                     "corner_01_pan", "corner_02_pan"]
        cls.state = {"shots": cls.shots, "current": "fly_up", "next": "heli_follow",
                     "targets": ["Driver"], "target_name": "Driver", "rehearsal": False,
                     "degraded": False, "target_lost": False, "running": False}

    def _run(self, body, extra=""):
        # `extra` must run before boot so key/state overrides are in place.
        return parse_result(run_node(self.js, body,
                                     extra=extra + "\n(new Function(PANEL_JS))();\n"))

    def test_layout_structure_and_self_contained_module(self):
        for sid in ["tally_bar", "arm_pill", "pgm", "prv", "keys_pill", "auth_pill",
                    "obs_pill", "reh_btn", "stop_btn", "reh", "deg", "desk",
                    "transport_card", "mode_btn", "take_btn", "pad_card", "shot_pads",
                    "shot_pads_extra", "cue_card", "q", "obs_quick", "rec_btn",
                    "rec_time", "obs_scene_pads", "field_card", "auto_follow",
                    "preview_card", "pv_canvas", "pv_meta", "drawer_setup",
                    "drawer_conn", "drawer_log", "toast", "obs_url", "obs_pw",
                    "obs_rem", "obs_sc"]:
            with self.subTest(id=sid):
                self.assertIn('id="%s"' % sid, self.lua)
        for snippet in ["position:sticky", "grid-template-columns:minmax(0,1.32fr)",
                        "@media(max-width:900px)", "KEYS PAUSED (Esc)",
                        "Preview→Take", "TAKE (Space)", "STOP (X)", "ON AIR",
                        "● REC", "--prog", "--prev"]:
            with self.subTest(snippet=snippet):
                self.assertIn(snippet, self.lua)
        self.assertIsNone(re.search(r"<(?:script|link)[^>]+(?:src|href)=", self.lua),
                          "panel must not load external CSS/JS")
        self.assertTrue(self.lua.rstrip().endswith("return M"))
        self.assertIn("]=]", self.lua)

    def test_setup_drawer_holds_loader_and_conn_drawer_holds_obs_fields(self):
        setup_start = self.lua.index('<details id="drawer_setup"')
        setup_end = self.lua.index('<details id="drawer_conn"', setup_start)
        setup = self.lua[setup_start:setup_end]
        for sid in ["track_loader_card", "live_events", "drop_zone", "paste_json",
                    "inbox_files", "pin_position", "saved_plans", "track_file"]:
            with self.subTest(setup=sid):
                self.assertIn('id="%s"' % sid, setup)
        conn_start = setup_end
        conn_end = self.lua.index('<details id="drawer_log"', conn_start)
        conn = self.lua[conn_start:conn_end]
        for sid in ["tok", "obs_url", "obs_pw", "obs_rem", "obs_sc",
                    "obsurl", "obspw", "obs_remember", "obsscene", "obsprev"]:
            with self.subTest(conn=sid):
                self.assertIn('id="%s"' % sid, conn)
        self.assertIn('<details id="panel_manual" class="card">', self.lua)
        self.assertLess(conn_end, self.lua.index('<details id="panel_manual"'))

    def test_camera_pad_grid_renders_primary_and_extra_shots(self):
        result = self._run(r"""
          const p=globalThis.racecamPanel;
          p.renderShotDeck(S);
          console.log(JSON.stringify({
            primary:document.getElementById('shot_pads').innerHTML,
            extra:document.getElementById('shot_pads_extra').innerHTML,
            sig:p.getDeckSig()}));
        """, extra="const S=" + json.dumps(self.state) + ";\n")
        primary, extra = result["primary"], result["extra"]
        self.assertEqual(primary.count("<button"), 9)
        for n in range(1, 10):
            self.assertIn('<span class="keycap">%d</span>' % n, primary)
        for label in ["Start Line", "Fly Up", "Auto Trackside", "Heli Follow",
                      "Follow Focus", "Front Chase", "Side Track", "Orbit Hero", "Flyover"]:
            with self.subTest(label=label):
                self.assertIn(label, primary)
        self.assertIn('class="pad-kind drone"', primary)
        self.assertIn('class="pad-kind follow"', primary)
        self.assertEqual(extra.count("<button"), 4)
        self.assertIn("Finish Line", extra)
        self.assertIn("Overview", extra)
        self.assertIn('data-rc-shot="corner_01_pan"', extra)
        self.assertIn('data-rc-shot="corner_02_pan"', extra)
        self.assertIn('class="shot-pad pgm" data-rc-shot="fly_up"', primary)
        self.assertIn('class="shot-pad prv" data-rc-shot="heli_follow"', primary)
        self.assertTrue(result["sig"])

    def test_cut_bus_pad_click_cuts_immediately(self):
        result = self._run(r"""
          await sleep(20);
          const p=globalThis.racecamPanel;
          const before=fetchLog.filter(x=>x.url==='/api/command').length;
          document.getElementById('shot_pads')._ev.click({
            target:{closest:()=>({getAttribute:()=> 'fly_up'})}});
          await sleep(20);
          console.log(JSON.stringify({
            mode:p.isTakeMode(),
            posts:fetchLog.filter(x=>x.url==='/api/command')
                           .map(x=>JSON.parse(x.opts.body)),
            before:before}));
        """, extra="globalThis.__stateOverride=" + json.dumps(self.state) + ";\n")
        self.assertFalse(result["mode"])
        self.assertEqual(result["before"], 0)
        self.assertIn({"cmd": "trigger", "args": "fly_up"}, result["posts"])

    def test_program_tally_syncs_on_poll(self):
        state2 = dict(self.state, current="orbit_hero", next="route_flyover")
        result = self._run(r"""
          await sleep(20);
          const first={html:document.getElementById('shot_pads').innerHTML,
            pgm:document.getElementById('pgm').textContent,
            prv:document.getElementById('prv').textContent,
            pill:document.getElementById('arm_pill').textContent};
          globalThis.__stateOverride=NEXT;
          await globalThis.racecamPanel.poll();
          await sleep(10);
          const second={html:document.getElementById('shot_pads').innerHTML,
            pgm:document.getElementById('pgm').textContent};
          console.log(JSON.stringify({first:first,second:second}));
        """, extra=("globalThis.__stateOverride=" + json.dumps(self.state) + ";\n"
                    "const NEXT=" + json.dumps(state2) + ";\n"))
        self.assertIn('class="shot-pad pgm" data-rc-shot="fly_up"', result["first"]["html"])
        self.assertEqual(result["first"]["pgm"], "PROGRAM fly_up")
        self.assertEqual(result["first"]["prv"], "PREVIEW heli_follow")
        self.assertEqual(result["first"]["pill"], "STANDBY")
        self.assertIn('class="shot-pad pgm" data-rc-shot="orbit_hero"', result["second"]["html"])
        self.assertNotIn('class="shot-pad pgm" data-rc-shot="fly_up"', result["second"]["html"])
        self.assertEqual(result["second"]["pgm"], "PROGRAM orbit_hero")

    def test_preview_take_mode_stages_then_space_takes(self):
        result = self._run(r"""
          await sleep(20);
          const p=globalThis.racecamPanel;
          p.toggleMode();
          document.getElementById('shot_pads')._ev.click({
            target:{closest:()=>({getAttribute:()=> 'fly_up'})}});
          await sleep(20);
          const staged={shot:p.getStagedShot(),
            prv:document.getElementById('prv').textContent,
            pads:document.getElementById('shot_pads').innerHTML,
            posts:fetchLog.filter(x=>x.url==='/api/command').length};
          keyHandler({key:' ',code:'Space',target:{tagName:'DIV'},preventDefault(){}});
          await sleep(20);
          const taken={shot:p.getStagedShot(),
            posts:fetchLog.filter(x=>x.url==='/api/command')
                          .map(x=>JSON.parse(x.opts.body))};
          console.log(JSON.stringify({staged:staged,taken:taken,
            mode:p.isTakeMode(),btn:document.getElementById('mode_btn').textContent,
            takeDisabled:document.getElementById('take_btn').disabled}));
        """, extra=("let keyHandler=null;\n"
                    "document.addEventListener=(ev,fn)=>{if(ev==='keydown')keyHandler=fn};\n"
                    "globalThis.__stateOverride=" + json.dumps(self.state) + ";\n"))
        staged = result["staged"]
        self.assertTrue(result["mode"])
        self.assertEqual(staged["posts"], 0, "pad click must not cut in Preview→Take mode")
        self.assertEqual(staged["shot"], "fly_up")
        self.assertEqual(staged["prv"], "PREVIEW fly_up")
        self.assertIn('class="shot-pad pgm prv" data-rc-shot="fly_up"', staged["pads"])
        self.assertIn({"cmd": "trigger", "args": "fly_up"}, result["taken"]["posts"])
        self.assertEqual(result["taken"]["shot"], "")
        self.assertEqual(result["btn"], "Preview→Take")
        self.assertFalse(result["takeDisabled"])

    def test_take_button_inline_onclick_executes_cut(self):
        m = re.search(r'id="take_btn"[^>]*onclick="([^"]+)"', self.lua)
        assert m, "take_btn has no inline onclick"
        self.assertEqual(m.group(1), "takeShot()")
        result = self._run(r"""
          await sleep(20);
          const p=globalThis.racecamPanel;
          p.toggleMode();
          p.stageShot('heli_follow');
          (new Function('takeShot', CLICK))(p.takeShot);
          await sleep(20);
          console.log(JSON.stringify({
            posts:fetchLog.filter(x=>x.url==='/api/command')
                          .map(x=>JSON.parse(x.opts.body)),
            staged:p.getStagedShot()}));
        """, extra=("globalThis.__stateOverride=" + json.dumps(self.state) + ";\n"
                    "const CLICK=" + json.dumps(m.group(1)) + ";\n"))
        self.assertIn({"cmd": "trigger", "args": "heli_follow"}, result["posts"])
        self.assertEqual(result["staged"], "")

    def test_keys_pill_and_escape_blur_restore_hotkeys(self):
        result = self._run(r"""
          const p=globalThis.racecamPanel;
          const inp=document.getElementById('tgt_name');
          inp.tagName='INPUT';
          let blurred=false;
          inp.blur=()=>{blurred=true;document.activeElement=null};
          document.activeElement=inp;
          p.updateKeysPill();
          const paused={text:document.getElementById('keys_pill').textContent,
                        cls:document.getElementById('keys_pill').className};
          keyHandler({key:'Escape',target:{tagName:'INPUT'},preventDefault(){}});
          const active={text:document.getElementById('keys_pill').textContent,
                        blurred:blurred,cleared:document.activeElement===null};
          console.log(JSON.stringify({paused:paused,active:active}));
        """, extra=("let keyHandler=null;\n"
                    "document.addEventListener=(ev,fn)=>{if(ev==='keydown')keyHandler=fn};\n"))
        self.assertEqual(result["paused"]["text"], "KEYS PAUSED (Esc)")
        self.assertIn("keys-paused", result["paused"]["cls"])
        self.assertEqual(result["active"]["text"], "KEYS ACTIVE")
        self.assertTrue(result["active"]["blurred"])
        self.assertTrue(result["active"]["cleared"])

    def test_drawer_defaults_and_auto_collapse_on_track_load(self):
        doc = {"RouteName": "Desk Test", "Waypoints": [
            {"Location": {"X": 0, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 3000, "Y": 0, "Z": 0}, "Scale3D": {"Y": 18}},
            {"Location": {"X": 3000, "Y": 3000, "Z": 0}, "Scale3D": {"Y": 18}}]}
        result = self._run(r"""
          await sleep(20);
          const p=globalThis.racecamPanel,d=id=>document.getElementById(id);
          const initial={setup:d('drawer_setup').open,conn:d('drawer_conn').open,
                         log:d('drawer_log').open};
          p.handleRawInput(JSON.stringify(DOC),'desk_test',false);
          await sleep(10);
          const loaded={setup:d('drawer_setup').open,meta:d('pv_meta').textContent};
          p.openSetup();
          const reopened=d('drawer_setup').open;
          p.collapseSetup();
          const closed=d('drawer_setup').open;
          const connOpened=p.toggleConnDrawer();
          console.log(JSON.stringify({initial:initial,loaded:loaded,reopened:reopened,
            closed:closed,connOpened:connOpened,connState:d('drawer_conn').open}));
        """, extra="const DOC=" + json.dumps(doc) + ";\n")
        self.assertTrue(result["initial"]["setup"], "setup drawer starts open with no route")
        self.assertFalse(result["initial"]["conn"])
        self.assertFalse(result["initial"]["log"])
        self.assertFalse(result["loaded"]["setup"], "setup auto-collapses after a track loads")
        self.assertIn("Desk Test", result["loaded"]["meta"])
        self.assertTrue(result["reopened"])
        self.assertFalse(result["closed"])
        self.assertTrue(result["connState"])

    def test_smoothing_preserved_and_zero_drive_paths(self):
        for mode in ("tight", "normal", "cinematic"):
            with self.subTest(mode=mode):
                self.assertIn('id="sm_%s"' % mode, self.lua)
                self.assertEqual(re.search(r'id="sm_%s"[^>]*onclick="([^"]+)"' % mode,
                                           self.lua).group(1), "setSmoothing('%s')" % mode)
        for snippet in ["const SMOOTHING_MODES=['tight','normal','cinematic']",
                        "return cmd('smoothing',mode)", "highlightSmoothing(sMode)"]:
            with self.subTest(js=snippet):
                self.assertIn(snippet, self.js)
        self.assertIsNone(re.search(r"\b[A-Z]:[\\/]", self.lua),
                          "no hardcoded Windows drive paths allowed")


class BroadcastFramingV2Tests(unittest.TestCase):
    """Phase 3: outside-apex corners, auto broadcast cameras, pad labels, standalone."""

    @classmethod
    def setUpClass(cls):
        cls.lua = PANEL.read_text(encoding="utf-8")
        cls.js = re.search(r"<script>([\s\S]*?)</script>", cls.lua, re.S).group(1)
        cls.init_lua = (ROOT / "ClientScripts/RaceCam/init.lua").read_text(encoding="utf-8")

    def node(self, body, extra=""):
        return parse_result(run_node(self.js, body,
                                     extra=extra + "\n(new Function(PANEL_JS))();\n"))

    @staticmethod
    def unit2(v):
        m = math.hypot(v[0], v[1])
        return [v[0] / m, v[1] / m]

    def test_corner_cams_outside_left_and_right_turns(self):
        # crossZ > 0: d_in=+X, d_out=+Y -> centre on leftNormal(+X)=+Y,
        # so the camera must go on -Y (rightNormal), 400 cm along +Y.
        left = [[-1000.0, 0.0, 0.0], [0.0, 0.0, 0.0],
                [0.0, 1000.0, 0.0], [1000.0, 1000.0, 0.0]]
        # crossZ < 0: d_in=+X, d_out=-Y -> camera on +Y (leftNormal).
        right = [[-1000.0, 0.0, 0.0], [0.0, 0.0, 0.0],
                 [0.0, -1000.0, 0.0], [1000.0, -1000.0, 0.0]]
        got = self.node(r"""
          const rp=globalThis.routePlanner, gates=[18,18,18,18];
          console.log(JSON.stringify(TRACKS.map(pts=>{
            const direct=rp.makeCornerCam(pts,gates,1,null);
            const plan=rp.buildShots('bend',pts,gates,{tracksideStride:'auto'});
            const fromPlan=plan.shots.find(s=>s.id==='corner_01_pan');
            const outN=rp.outsideNormal(pts,1), c=pts[1];
            return {direct:direct, fromPlan:fromPlan, outward:outN,
              dot:outN[0]*(direct.location[0]-c[0])+outN[1]*(direct.location[1]-c[1])};
          })));
        """, extra="const TRACKS=" + json.dumps([left, right]) + ";\n")
        self.assertEqual(len(got), 2)
        for label, bend, expected_y, expected_at_y in [
                ("left (crossZ>0)", got[0], -1000.0, 800.0),
                ("right (crossZ<0)", got[1], 1000.0, -800.0)]:
            with self.subTest(turn=label):
                cam = bend["direct"]
                self.assertEqual(cam["id"], "corner_01_pan")
                self.assertEqual(cam["kind"], "trackside_pan")
                self.assertEqual(cam["role"], "trackside")
                self.assertEqual(cam["fov"], 45.0)
                self.assertEqual(cam["fov_min"], 13.0)
                self.assertEqual(cam["fov_max"], 58.0)
                self.assertTrue(cam["auto_zoom"])
                self.assertAlmostEqual(cam["location"][0], 0.0, places=2)
                self.assertAlmostEqual(cam["location"][1], expected_y, places=2)
                self.assertAlmostEqual(cam["location"][2], 240.0, places=2)
                self.assertAlmostEqual(cam["look_at"][1], expected_at_y, places=2)
                self.assertGreater(bend["dot"], 500.0,
                                   "camera must sit on the OUTSIDE of the bend")
                self.assertEqual(bend["fromPlan"]["location"], cam["location"],
                                 "buildShots must use the same outside-apex camera")

    def test_broadcast_specialty_and_rig_shots(self):
        pts = [[0.0, 0.0, 0.0], [20000.0, 0.0, 0.0], [20000.0, 1000.0, 0.0],
               [10000.0, 1000.0, 0.0], [10000.0, 15000.0, 0.0], [0.0, 15000.0, 0.0]]
        gates = [18.0] * len(pts)
        got = self.node(r"""
          const rp=globalThis.routePlanner;
          const plan=rp.buildShots('broadcast',PTS,GATES,{tracksideStride:'auto'});
          const pick=id=>plan.shots.find(s=>s.id===id);
          const k=rp.longestStraightIndex(PTS), ci=rp.sharpestCornerIndex(PTS);
          console.log(JSON.stringify({
            ids:plan.shots.map(s=>s.id), first9:plan.shots.slice(0,9).map(s=>s.id),
            straight:pick('straight_telephoto'), curb:pick('curb_apex'),
            crane:pick('start_crane'),
            rigs:[pick('onboard_tcam'),pick('rear_battle'),pick('pack_battle')],
            k:k, segA:PTS[k], segB:PTS[(k+1)%PTS.length],
            ci:ci, cornerPt:PTS[ci], startPt:PTS[0], curbNormal:rp.outsideNormal(PTS,ci)
          }));
        """, extra="const PTS=" + json.dumps(pts) + ";\nconst GATES=" + json.dumps(gates) + ";\n")
        self.assertEqual(got["first9"], UNIVERSAL, "hotkeys 1-9 must stay untouched")
        for sid in ["onboard_tcam", "rear_battle", "pack_battle",
                    "straight_telephoto", "curb_apex", "start_crane"]:
            self.assertIn(sid, got["ids"], sid)
        by_id = dict(zip(got["ids"], [None] * len(got["ids"])))
        self.assertIn("finish_line", by_id)
        self.assertIn("overview", by_id)
        self.assertTrue(any(i.startswith("corner_") for i in got["ids"]))

        s = got["straight"]
        self.assertEqual(s["kind"], "trackside_pan")
        self.assertEqual(s["role"], "trackside")
        self.assertEqual(s["fov"], 35.0)
        self.assertTrue(s["auto_zoom"])
        self.assertEqual(s["fov_min"], 12.0)
        self.assertEqual(s["fov_max"], 46.0)
        a, b, d = got["segA"], got["segB"], self.unit2([got["segB"][0] - got["segA"][0],
                                                        got["segB"][1] - got["segA"][1]])
        expected = [a[0] + 0.9 * (b[0] - a[0]) - d[1] * 450.0,
                    a[1] + 0.9 * (b[1] - a[1]) + d[0] * 450.0, a[2] + 220.0]
        for x, y in zip(expected, s["location"]):
            self.assertAlmostEqual(x, y, delta=1e-2)
        self.assertEqual(s["look_at"], [a[0], a[1], a[2]], "must look back down the straight")

        curb = got["curb"]
        self.assertEqual(curb["kind"], "trackside_pan")
        self.assertEqual(curb["role"], "trackside")
        self.assertEqual(curb["fov"], 62.0)
        self.assertTrue(curb["auto_zoom"])
        self.assertEqual(curb["fov_min"], 24.0)
        self.assertEqual(curb["fov_max"], 72.0)
        c = got["cornerPt"]
        self.assertAlmostEqual(curb["location"][2] - c[2], 55.0, places=2)
        outward = curb["location"][0] - c[0], curb["location"][1] - c[1]
        self.assertAlmostEqual(math.hypot(*outward), 320.0, places=2)
        dot = outward[0] * got["curbNormal"][0] + outward[1] * got["curbNormal"][1]
        self.assertGreater(dot, 300.0, "curb camera must be on the outside apex")

        crane = got["crane"]
        self.assertEqual(crane["kind"], "trackside_pan")
        self.assertEqual(crane["role"], "trackside")
        self.assertEqual(crane["fov"], 48.0)
        self.assertTrue(crane["auto_zoom"])
        self.assertEqual(crane["fov_min"], 18.0)
        self.assertEqual(crane["fov_max"], 56.0)
        d0 = self.unit2([pts[1][0] - pts[0][0], pts[1][1] - pts[0][1]])
        n0 = [-d0[1], d0[0]]
        offset = 900.0 + 350.0 + 400.0
        expected = [pts[0][0] - 800.0 * d0[0] + offset * n0[0],
                    pts[0][1] - 800.0 * d0[1] + offset * n0[1], pts[0][2] + 1400.0]
        for x, y in zip(expected, crane["location"]):
            self.assertAlmostEqual(x, y, delta=1e-2)
        self.assertEqual(crane["look_at"], [600.0, 0.0, 0.0])

        want_rigs = [("onboard_tcam", "follow", 78.0), ("rear_battle", "follow", 68.0),
                     ("pack_battle", "pack_battle", 68.0)]
        for rig, (sid, kind, fov) in zip(got["rigs"], want_rigs):
            with self.subTest(rig=sid):
                self.assertEqual(rig["id"], sid)
                self.assertEqual(rig["kind"], kind)
                self.assertEqual(rig["preset"], sid)
                self.assertEqual(rig["fov"], fov)
                self.assertEqual(rig["target"], "focus")
                self.assertEqual(rig["trigger"], {"type": "manual"})

    def test_new_shot_labels_and_pad_grid(self):
        shots = UNIVERSAL + ["finish_line", "overview", "onboard_tcam", "rear_battle",
                             "pack_battle", "straight_telephoto", "curb_apex",
                             "start_crane", "corner_01_pan"]
        state = {"shots": shots, "current": "start_line", "next": "", "targets": ["Driver"],
                 "target_name": "Driver", "rehearsal": False, "degraded": False,
                 "target_lost": False, "running": False}
        got = self.node(r"""
          const p=globalThis.racecamPanel;
          p.renderShotDeck(S);
          console.log(JSON.stringify({
            primary:document.getElementById('shot_pads').innerHTML,
            extra:document.getElementById('shot_pads_extra').innerHTML}));
        """, extra="const S=" + json.dumps(state) + ";\n")
        self.assertEqual(got["primary"].count("<button"), 9)
        for n in range(1, 10):
            self.assertIn('<span class="keycap">%d</span>' % n, got["primary"])
        self.assertEqual(got["extra"].count("<button"), len(shots) - 9)
        for label in ["Onboard T-Cam", "Rear Battle", "Pack Battle",
                      "Straight Tele", "Curb Apex", "Start Crane"]:
            with self.subTest(label=label):
                self.assertIn(label, got["extra"])
        for sid, kind in [("onboard_tcam", "follow"), ("rear_battle", "follow"),
                          ("pack_battle", "follow"), ("straight_telephoto", "trackside"),
                          ("curb_apex", "trackside"), ("start_crane", "trackside")]:
            with self.subTest(shot=sid):
                self.assertIn('data-rc-shot="%s"' % sid, got["extra"])
                m = re.search(r'<button[^>]*data-rc-shot="%s"[^>]*>(.*?)</button>'
                              % re.escape(sid), got["extra"], re.S)
                self.assertIsNotNone(m, sid)
                self.assertIn("pad-kind %s" % kind, m.group(1))

    def test_standalone_default_plan_has_new_rigs(self):
        block = self.init_lua[self.init_lua.index("local function default_plan()"):
                              self.init_lua.index("--- Load .json first")]
        for line in [
                '{ id = "onboard_tcam", kind = "follow", trigger = { type = "manual" }, target = "focus", preset = "onboard_tcam", fov = 78.0 }',
                '{ id = "rear_battle", kind = "follow", trigger = { type = "manual" }, target = "focus", preset = "rear_battle", fov = 68.0 }',
                '{ id = "pack_battle", kind = "pack_battle", trigger = { type = "manual" }, target = "focus", preset = "pack_battle", fov = 68.0 }']:
            with self.subTest(shot=line):
                self.assertIn(line, block)

    def test_zero_drive_paths_and_no_external_assets(self):
        self.assertIsNone(re.search(r"\bD:[\\/]", self.lua))
        self.assertIsNone(re.search(r"<(?:script|link)[^>]+(?:src|href)=", self.lua))


if __name__ == "__main__":
    unittest.main()
