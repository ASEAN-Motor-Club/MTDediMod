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
  else if (url === '/api/live_events') j = {events:[{name:'Current Trial', is_member:true,
    waypoints:[{x:0,y:0,z:0,gate_m:18},{x:4000,y:0,z:0,gate_m:18},{x:8000,y:0,z:0,gate_m:18}]}]};
  else if (url === '/api/plans') j = {plans:[]};
  return {json: async () => j};
};
globalThis.WebSocket = class { constructor(u){ this.url = u; this.readyState = 0; } send(){} close(){} };
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


if __name__ == "__main__":
    unittest.main()
