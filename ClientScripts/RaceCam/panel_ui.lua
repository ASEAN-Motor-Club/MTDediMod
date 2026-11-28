-- RaceCam/panel_ui.lua — operator control-panel markup and client JS.
--
-- Kept in its own module so http.lua only has to serve a string: all panel
-- behaviour (and, critically, ALL broadcast controls/hotkeys) lives here.
-- Returns { HTML = [=[ <!doctype html> ... ]=] }.
--
-- Zero Python / zero server round-trips are needed to plan a route: the exact
-- deterministic port of amc-racecam/route_to_shots.py is below in
-- window.routePlanner, and the 2D <canvas> previews the same shot suite.
local M = {}

M.HTML = [=[<!doctype html><html><head><meta charset="utf-8"><title>AMC RaceCam</title>
<style>
:root{--bg:#0d1117;--surface:#161b22;--surface2:#1c2430;--line:#30363d;--ink:#e6edf3;
  --muted:#8b949e;--prog:#e53935;--prev:#2fbf71;--warn:#f0a020;--accent:#58a6ff}
*{box-sizing:border-box}
body{font:13px/1.4 system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:var(--bg);
  color:var(--ink);margin:0;padding:0 12px 12px}
h1{font-size:15px;margin:0;white-space:nowrap}h2{font-size:13px;margin:0 0 6px;color:#c9d1d9}
.card{background:var(--surface);border:1px solid var(--line);border-radius:7px;padding:9px 10px;margin:0}
.card-head{display:flex;align-items:center;justify-content:space-between;gap:8px;margin-bottom:7px}
button{background:#234a73;border:1px solid #315f8f;color:#fff;padding:6px 10px;border-radius:5px;
  cursor:pointer;margin:0;font:inherit}
button:hover{background:#2d6096}button:disabled{background:#30363d;border-color:#3d444d;color:#7d8590;cursor:not-allowed}
input,select,textarea{background:#0d1117;color:var(--ink);border:1px solid var(--line);padding:5px 7px;border-radius:4px;font:inherit}
input[type=checkbox]{width:auto;accent-color:var(--accent)}label{margin-right:8px}
pre{background:#080b0f;border:1px solid var(--line);padding:8px;max-height:200px;overflow:auto;white-space:pre-wrap;font:11px ui-monospace,monospace}
.kbd{color:var(--muted);font-size:11px}
.muted{color:var(--muted);font-size:11px}
.badge{display:inline-block;padding:4px 9px;border-radius:4px;font-weight:700;font-size:11px;margin-right:5px;white-space:nowrap}
.tally-on-prog{background:var(--prog);color:#fff;box-shadow:0 0 9px rgba(229,57,53,.45)}
.tally-on-prev{background:var(--prev);color:#06281a}.tally-off{background:#30363d;color:#8b949e}
/* Sticky top tally bar — always visible, even while a drawer is open. */
#tally_bar{position:sticky;top:0;z-index:30;display:flex;align-items:center;gap:6px;flex-wrap:nowrap;
  min-height:52px;padding:6px 10px;margin:0 -12px 0;background:#0b0f14;border-bottom:1px solid var(--line);
  box-shadow:0 2px 14px rgba(0,0,0,.55)}
.brand{font-size:12px;letter-spacing:.5px;color:var(--muted);white-space:nowrap}.brand b{color:var(--prog)}
.pill{font-size:10px;font-weight:700;letter-spacing:.4px;padding:5px 9px;border-radius:12px;
  background:#21262d;border:1px solid var(--line);color:#c9d1d9;white-space:nowrap}
.pill.armed{background:#1b4332;border-color:var(--prev);color:#9ae6b4}
.pill.standby{background:#3d2f10;border-color:#8a6d1f;color:#f6e05e}
.pill.ok{background:#17301f;border-color:var(--prev);color:#9ae6b4}
.pill.rec{background:#4a1418;border-color:var(--prog);color:#ffb3b3}
.pill.keys-on{background:#17301f;border-color:var(--prev);color:#9ae6b4}
.pill.keys-paused{background:#432c0c;border-color:var(--warn);color:#fbd38d}
.onair-wrap,.cd-wrap{display:flex;align-items:center;gap:4px;font-size:10px;color:var(--muted);white-space:nowrap}
.onair-wrap input{width:110px;font-size:11px;padding:3px 6px}
.cd-wrap b{font:700 13px ui-monospace,monospace;color:#fbd38d}
.mini{padding:3px 7px;font-size:11px}
.panic{background:var(--prog);border-color:#ff6b6b;color:#fff;font-weight:800;letter-spacing:.6px;
  padding:8px 13px;box-shadow:0 0 12px rgba(229,57,53,.5)}
.panic:hover{background:#ff4d4d}
.alert{display:none;font-weight:700;font-size:12px;padding:5px 10px;border-radius:0;margin:0 -12px 2px}
.alert.on{display:block}.alert.deg{background:#742a2a;color:#fff}.alert.reh{background:#7a5310;color:#fff}
/* Zero-scroll two-column broadcast desk. */
#desk{display:grid;grid-template-columns:minmax(0,1.32fr) minmax(0,1fr);gap:9px;align-items:start;padding-top:8px}
.col-left,.col-right{display:flex;flex-direction:column;gap:8px;min-width:0}
.transport{display:flex;flex-wrap:wrap;gap:5px;margin-bottom:7px}
.t-arm{background:#7a5c12;border-color:#b8860b}.t-start{background:#1b6b43;border-color:var(--prev)}
.t-next{background:#234a73}.t-undo{background:#30363d;border-color:#484f58}
.t-mode{background:#3b2d63;border-color:#6b5ca5}.t-mode.on{background:#2f855a;border-color:var(--prev)}
.t-take{background:#8a2d34;border-color:var(--prog);font-weight:800}
.select-row{display:flex;gap:6px;align-items:center;margin-top:6px}.select-row select{flex:1 1 auto;min-width:0}
/* Stream-deck camera pad grid. */
.pad-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:6px}
.pad-grid.extra{grid-template-columns:repeat(auto-fill,minmax(92px,1fr));margin-top:6px}
.shot-pad{position:relative;display:flex;flex-direction:column;align-items:flex-start;justify-content:flex-end;
  min-height:56px;margin:0;padding:7px 8px;text-align:left;border:1px solid #3a4756;border-radius:6px;
  background:linear-gradient(#1f2733,#151c25);color:var(--ink);font-weight:600;overflow:hidden}
.shot-pad:hover{background:#26364a;border-color:#4b6584}
.shot-pad.pgm{border-color:var(--prog);box-shadow:0 0 0 2px rgba(229,57,53,.35),0 0 14px rgba(229,57,53,.42);
  background:linear-gradient(#3d1719,#241012)}
.shot-pad.prv{border-color:var(--prev);box-shadow:0 0 0 2px rgba(47,191,113,.35)}
.keycap{position:absolute;top:5px;left:6px;background:#0b0f14;border:1px solid #48586b;border-radius:4px;
  padding:0 5px;font:11px ui-monospace,monospace;color:#9fb3c8}
.pad-label{font-size:12px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:100%}
.pad-kind{font-size:9px;text-transform:uppercase;letter-spacing:.6px;color:var(--muted)}
.pad-kind.drone{color:#63b3ed}.pad-kind.follow{color:#68d391}.pad-kind.trackside{color:#f6ad55}.pad-kind.hero{color:#d6bcfa}
.onair-dot{position:absolute;top:5px;right:5px;background:var(--prog);color:#fff;border-radius:8px;
  padding:0 5px;font-size:9px;font-weight:800}
.cue-chips{display:flex;flex-wrap:wrap;gap:5px;min-height:22px;margin:4px 0}
.cue-chip{background:#21262d;border:1px solid var(--line);border-radius:12px;padding:2px 6px;font-size:11px}
.cue-x{border:0;background:transparent;color:var(--muted);padding:0 3px;font-size:13px;line-height:1}
.muted-btn{background:#262c34;border-color:#3d444d;color:#a9b2bd}
.rec{background:#4a1418;border-color:var(--prog);font-weight:800;animation:recpulse 1.6s ease-in-out infinite}
.rec.on{background:var(--prog);color:#fff}
@keyframes recpulse{0%,100%{opacity:1}50%{opacity:.55}}
.scene-pad{padding:6px 8px;font-size:11px;background:#1f2733;border-color:#3a4756}
.scene-pad.pgm{border-color:var(--prog);box-shadow:0 0 0 2px rgba(229,57,53,.35)}
.head-toggles{display:flex;align-items:center;gap:5px;flex-wrap:wrap}.tog{font-size:10px;padding:4px 7px}
.tog.on{background:#1b6b43;border-color:var(--prev)}
.dir-ctl{display:inline-flex;align-items:center;gap:3px;white-space:nowrap}
#dir_badge{font-size:10px;max-width:290px;overflow:hidden;text-overflow:ellipsis}
/* Contestants / live leaderboard (click-safe button deck). */
.roster{display:flex;flex-direction:column;gap:3px;margin-top:5px;max-height:300px;overflow:auto}
.roster.standalone{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:5px}
.roster button.rc-driver{display:flex;align-items:center;gap:6px;width:100%;margin:0;
  padding:5px 7px;text-align:left;background:#1f2733;border:1px solid #3a4756;border-radius:4px}
.roster button.rc-driver:hover{background:#2a3a4d}
.roster button.rc-driver.onair{border-color:#48bb78;box-shadow:inset 0 0 0 1px #48bb78;background:#17301f}
.rc-pos{flex:0 0 30px;text-align:center;font-weight:bold;border-radius:3px;padding:2px 3px;background:#444;color:#ddd;font-size:11px}
.rc-pos.p1{background:#b8860b;color:#fff}.rc-pos.p2{background:#8a8a8a;color:#fff}
.rc-pos.p3{background:#8c5a2b;color:#fff}.rc-pos.dq{background:#5a2323;color:#e8a0a0}
.rc-name{flex:1 1 auto;font-weight:bold;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:12px}
.rc-tele{margin-left:auto;font-family:ui-monospace,monospace;font-size:10px;color:#cbd5e0;text-align:right;white-space:nowrap}
.rc-gap{color:#f6ad55}
.onair-pill{background:#48bb78;color:#06281a;border-radius:10px;padding:1px 6px;font-size:10px;font-weight:bold;margin-left:6px}
.status-pill{font-size:10px;padding:1px 7px;border-radius:9px;margin-left:6px;background:#2b6cb0;color:#fff}
.status-pill.counting{background:#975a16}.status-pill.racing{background:#2f855a}
.status-pill.finished{background:#4a5568;color:#e2e8f0}
#pv_canvas{display:block;width:100%;height:auto;max-height:200px;background:#080b0f;border:1px solid var(--line);
  border-radius:4px;margin-top:6px}
#drop_zone{border:1px dashed #555;border-radius:6px;padding:10px;text-align:center;color:#999;margin:6px 0;cursor:pointer}
#drop_zone.over{background:#234;color:#fff}
.card.drop-over{border-color:#63b3ed;background:#1c2733;box-shadow:inset 0 0 0 2px rgba(99,179,237,.35)}
.badge.standalone{background:#2b6cb0;color:#fff;font-weight:normal}
#paste_json{width:100%;height:80px;font-family:ui-monospace,monospace;font-size:11px;resize:vertical}
.pin-row button{padding:4px 8px;font-size:11px}
.sm-btn{padding:4px 9px;font-size:11px}
.sm-btn.on{background:#1b6b43;border-color:var(--prev);color:#9ae6b4;box-shadow:inset 0 0 0 1px var(--prev)}
hr{border:0;border-top:1px solid var(--line);margin:8px 0}
/* Collapsible drawers + 1-line toast. */
.drawer{margin-top:8px}.drawer>summary{cursor:pointer;color:var(--accent);font-weight:700}
.drawer>summary strong{color:var(--ink)}
.drawer[open]>summary{margin-bottom:8px;border-bottom:1px solid var(--line);padding-bottom:6px}
#footer_bar{display:flex;justify-content:space-between;gap:10px;align-items:center;margin-top:8px;
  padding:5px 10px;background:#0b0f14;border:1px solid var(--line);border-radius:6px}
#toast{font-size:11px;color:#9ae6b4;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:45%}
#panel_manual summary{cursor:pointer;color:#63b3ed}
#panel_manual summary strong{color:#eee}
#panel_manual h3{font-size:13px;margin:14px 0 6px;color:#63b3ed}
#panel_manual ol,#panel_manual ul{margin:6px 0;padding-left:22px}
#panel_manual li{margin:4px 0;line-height:1.45}
#panel_manual code{background:#080b0f;border:1px solid var(--line);border-radius:3px;padding:1px 4px;font-family:ui-monospace,monospace;font-size:12px}
#panel_manual[open]>summary{margin-bottom:8px;border-bottom:1px solid var(--line);padding-bottom:6px}
@media(max-width:900px){#desk{grid-template-columns:minmax(0,1fr)}#tally_bar{flex-wrap:wrap}.brand{display:none}}
</style></head><body>
<header id="tally_bar">
  <div class="brand">AMC <b>RACE</b>CAM</div>
  <button id="arm_pill" class="pill standby" onclick="cmd('arm')">STANDBY</button>
  <span id="pgm" class="badge tally-off">PROGRAM —</span>
  <span id="prv" class="badge tally-off">PREVIEW —</span>
  <span id="dir_badge" class="badge tally-off" style="display:none">AUTO —</span>
  <span class="onair-wrap">ON AIR <input id="tgt_name" size="12" placeholder="driver name"><button class="mini" onclick="lockTyped()">Lock</button></span>
  <span class="cd-wrap">COUNTDOWN <b id="cd">—</b></span>
  <span id="keys_pill" class="pill keys-on">KEYS ACTIVE</span>
  <span class="dir-ctl" title="In-game HUD visibility: Full, Tags Only (hides HUD, keeps player name tags), or Clean (hides both)">
    <span class="muted">HUD:</span>
    <button id="hud_full" class="sm-btn on" onclick="setHudMode('full')">Full</button>
    <button id="hud_tags" class="sm-btn" onclick="setHudMode('tags_only')">Tags Only</button>
    <button id="hud_clean" class="sm-btn" onclick="setHudMode('clean')">Clean</button>
  </span>
  <button id="auth_pill" class="pill" onclick="toggleConnDrawer()">Auth</button>
  <button id="obs_pill" class="pill" onclick="toggleConnDrawer()">OBS OFF</button>
  <button id="reh_btn" class="pill" onclick="toggleRehearsal()">REHEARSAL (R)</button>
  <button id="stop_btn" class="panic" onclick="cmd('stop')">STOP (X)</button>
</header>
<div id="reh" class="alert reh"></div>
<div id="deg" class="alert deg"></div>
<div class="muted" style="padding:1px 10px">Shot <b id="shot">—</b> · FOV <b id="fov">—</b> · Plan <b id="plan">—</b> · HB <b id="hb">—</b> · Camera <b id="run">—</b></div>
<div id="banner" style="display:none"></div>
<span id="prog" class="badge tally-off" style="display:none">PROGRAM —</span>
<span id="rehb" class="muted" style="display:none">OFF</span>
<main id="desk">
  <section class="col-left">
    <div class="card" id="transport_card">
      <div class="card-head"><h2>Switching Desk</h2><span class="muted">Color-coded transport · cut bus</span></div>
      <div class="transport">
        <button class="t-arm" onclick="cmd('arm')">Arm (A)</button>
        <button class="t-start" onclick="cmd('start')">Start (S)</button>
        <button class="t-next" onclick="cmd('next')">Next cue (N)</button>
        <button class="t-undo" onclick="undo()">Undo (Z)</button>
        <button id="mode_btn" class="t-mode" onclick="toggleMode()">Cut Bus</button>
        <button id="take_btn" class="t-take" onclick="takeShot()" disabled>TAKE (Space)</button>
      </div>
      <div class="pin-row">Smoothing:
        <button id="sm_tight" class="sm-btn" onclick="setSmoothing('tight')">Tight</button>
        <button id="sm_normal" class="sm-btn on" onclick="setSmoothing('normal')">Normal</button>
        <button id="sm_cinematic" class="sm-btn" onclick="setSmoothing('cinematic')">Cinematic</button>
        <button id="sm_tune_btn" class="sm-btn" onclick="toggleSmoothingTune()">Tune</button>
      </div>
      <div id="sm_tune_box" style="display:none;margin:6px 0 8px;padding:8px;background:#101624;border:1px solid #263147;border-radius:6px;font-size:12px">
        <div class="pin-row" style="gap:8px;flex-wrap:wrap">
          <label>Pos τ <input id="sm_tau_pos" type="range" min="0.05" max="2.00" step="0.02" value="0.28" oninput="onSmoothingInput()"> <span id="sm_tau_pos_v">0.28s</span></label>
          <label>Hdg τ <input id="sm_tau_hdg" type="range" min="0.05" max="2.50" step="0.05" value="0.38" oninput="onSmoothingInput()"> <span id="sm_tau_hdg_v">0.38s</span></label>
          <label>Look τ <input id="sm_tau_look" type="range" min="0.05" max="1.50" step="0.02" value="0.22" oninput="onSmoothingInput()"> <span id="sm_tau_look_v">0.22s</span></label>
          <label>FOV τ <input id="sm_tau_fov" type="range" min="0.05" max="1.50" step="0.05" value="0.25" oninput="onSmoothingInput()"> <span id="sm_tau_fov_v">0.25s</span></label>
          <label title="Uncheck for pure EMA damping with zero velocity prediction"><input id="sm_predict" type="checkbox" checked onchange="onSmoothingInput()"> Predict</label>
          <button id="sm_reset" class="mini" onclick="resetSmoothingTune()">Reset</button>
        </div>
      </div>
      <div class="select-row"><select id="sid"></select><button class="mini" onclick="trigger(sid.value)">Fire selected</button></div>
    </div>
    <div class="card" id="pad_card">
      <div class="card-head"><h2>Camera Pads</h2><span class="muted">1–9 primary · click to cut</span></div>
      <div id="shot_pads" class="pad-grid"></div>
      <div id="shot_pads_extra" class="pad-grid extra"></div>
    </div>
    <div class="card" id="cue_card">
      <div class="card-head"><h2>Cue Rundown</h2>
        <span class="muted">At t+ <input id="qat" size="5" placeholder="t+ sec">
        <button class="mini" onclick="enqueue()">Queue cue (Q)</button>
        <button class="muted-btn mini" onclick="cmd('queue_clear')">Clear queue</button></span>
      </div>
      <div id="q" class="cue-chips"></div>
      <div id="queue" class="muted">—</div>
    </div>
    <div class="card" id="obs_quick" style="display:none">
      <div class="card-head"><h2>OBS Scene Pads</h2>
        <span><button id="rec_btn" class="rec" onclick="toggleRec()">● REC</button>
        <span id="rec_time" class="muted">00:00</span></span></div>
      <div id="obs_scene_pads" class="pad-grid extra"></div>
    </div>
  </section>
  <section class="col-right">
    <div class="card" id="field_card">
      <div class="card-head">
        <div id="standings_hdr" class="kbd">Live Vehicles (click to target)</div>
        <span class="head-toggles">
          <label class="tog" title="Auto-Start on Green Light"><input id="auto_start" type="checkbox" onchange="postAutoFlags()"> Auto-Start on Green Light</label>
          <button id="auto_follow" class="tog" title="Follow Race Leader" onclick="toggleFollow()">Follow Leader</button>
          <input id="follow_leader" type="checkbox" onchange="postAutoFlags()" style="display:none">
          <span class="dir-ctl" title="Auto Director: hands-off camera / contestant selection">
            <span class="muted">Auto:</span>
            <button id="dir_off" class="sm-btn on" onclick="setDirector('off')">Off</button>
            <button id="dir_shots" class="sm-btn" onclick="setDirector('shots')">Auto Shots</button>
            <button id="dir_full" class="sm-btn" onclick="setDirector('full')">Auto Full</button>
          </span>
        </span>
      </div>
      <div id="contestants" class="roster"></div>
      <div class="muted">Manual target: type in the ON AIR field above, then Lock.</div>
    </div>
    <div class="card" id="preview_card">
      <div class="card-head"><h2>Track Preview</h2><button class="mini" onclick="openSetup()">Change Track</button></div>
      <canvas id="pv_canvas" width="640" height="320"></canvas>
      <div id="pv_meta" class="muted">No route loaded</div>
      <div id="track_info" class="muted">No route loaded. Planner runs entirely in this page — no Python needed.</div>
      <canvas id="track_canvas" width="640" height="320" style="display:none"></canvas>
    </div>
  </section>
</main>
<footer id="footer_bar"><span id="toast">Ready</span>
<span class="kbd">A arm · S start · X stop · 1-9 trigger shot · Alt+1-9 target contestant · N next cue · Z last-shot undo · R rehearsal toggle · Esc release focus · Space take</span></footer>
<details id="drawer_setup" class="card drawer">
  <summary><strong>Track &amp; Event Setup</strong> — live event, upload / drop / paste, pins, saved plans</summary>
  <div class="card" id="track_loader_card"><h2>Track Loader &amp; Live Event</h2>
  <span class="badge standalone" id="standalone_badge" style="display:none">Standalone / File Mode — manual Start (S) &amp; driver target active</span>
  <div id="live_current" class="muted">No in-game event detected</div>
  <button id="live_refresh" onclick="refreshLiveEvents()">Refresh events</button>
  <button id="live_load_btn" onclick="loadCurrentLiveEvent()" disabled>Load &amp; Preview</button><br>
  Server events: <select id="live_events"></select>
  <button onclick="applySelectedLiveEvent()">Load &amp; Apply selected</button><br>
  <div class="kbd">Auto flags are opt-in and sent to /api/auto_flags only when you tick them.</div>
  <hr>
  <div>Track JSON: <input id="track_file" type="file" accept=".json,.txt,application/json,text/plain">
  <button onclick="pickTrackFile()">Choose file</button></div>
  <div id="drop_zone">or drop a .json / .txt event, route or plan file anywhere on this card</div>
  <label><input id="auto_apply" type="checkbox"> Auto-apply on drop</label>
  <details style="margin:6px 0">
  <summary class="muted">Paste JSON (Discord code blocks welcome)</summary>
  <textarea id="paste_json" placeholder='Paste an event / route / plan JSON here — ```json fences are stripped automatically'></textarea>
  <button id="paste_preview" onclick="parsePasted()">Parse &amp; Preview</button>
  </details>
  <hr>
  <div><b>Dropped Files (racecam/inbox/)</b> <button id="inbox_refresh" onclick="refreshInbox()">Refresh</button><br>
  <select id="inbox_files"></select>
  <button id="inbox_load" onclick="loadInboxFile()">Load Dropped File</button></div>
  <hr>
  <div class="pin-row"><b>Free-Roam Pins</b>
  <button id="pin_position" onclick="pinPosition()">Pin Position</button>
  <button id="pin_undo" onclick="undoPin()">Undo Pin</button>
  <button id="pin_clear" onclick="clearPins()">Clear Pins</button>
  <span id="pin_count" class="muted">0 pins</span>
  <button id="pin_build" onclick="buildPins()" disabled>Build &amp; Load Pins</button></div>
  <hr>
  Saved plans: <select id="saved_plans"></select>
  <button id="plans_refresh" onclick="refreshPlans()">Refresh</button>
  <button id="plan_load" onclick="loadPlanFromServer()">Load &amp; Apply</button>
  </div>
</details>
<details id="drawer_conn" class="card drawer">
  <summary><strong>Auth &amp; OBS Settings</strong> — token and OBS WebSocket</summary>
  <div class="pin-row">Token: <input id="tok" type="password" placeholder="optional"> <button onclick="save()">Set</button></div>
  <div class="pin-row">OBS WebSocket: <input id="obs_url" size="28" value="ws://127.0.0.1:4455">
    <input id="obsurl" size="28" value="ws://127.0.0.1:4455" style="display:none">
    Password: <input id="obs_pw" type="password" size="16">
    <input id="obspw" type="password" size="12" style="display:none"></div>
  <div class="pin-row"><button onclick="obsConnect()">Connect</button> <button onclick="obsDisc()">Disconnect</button>
    <span id="obsst">disconnected</span>
    <button id="obs_check" onclick="obsCheck()">Check OBS</button>
    <label><input id="obs_rem" type="checkbox"> Remember OBS password on this PC</label>
    <input id="obs_remember" type="checkbox" style="display:none"></div>
  <div class="pin-row"><button onclick="obsRec(true)">Start record</button><button onclick="obsRec(false)">Stop record</button>
    Scene: <select id="obs_sc" onchange="obsSources()"></select>
    <select id="obsscene" onchange="obsSources()" style="display:none"></select>
    <button onclick="obsScenes()">Refresh scenes</button>
    <button onclick="obsSetScene()">Go to scene</button></div>
  <div class="pin-row">Source: <select id="obssrc"></select> <button onclick="obsShot()">Preview</button></div>
  <img id="obsprev" style="max-width:320px;display:none;border:1px solid #444;margin-top:6px">
</details>
<details id="drawer_log" class="card drawer"><summary><strong>Raw Log</strong> — latest command results</summary>
<pre id="out"></pre></details>
<details id="panel_manual" class="card">
<summary><strong>Operator Guide — How to Use This Panel</strong> (click to expand)</summary>
<div class="kbd">This page is your local broadcast desk: tracks go in, camera shots come out, OBS follows along. Nothing here needs Python on the game PC.</div>

<h3>1. Quick Start (4 steps)</h3>
<ol>
<li>In Motor Town press <code>Ctrl+Shift+F10</code> to open the admin overlay, then click <strong>Load Current Event &amp; Open Panel</strong>. The auth token is appended to the browser URL automatically — no copying by hand. RaceCam starts in <strong>standby</strong>: your own view is not hijacked until you arm or cut to a shot.</li>
<li>Load a track using one of the four paths below, or skip it and use <strong>Quick Follow</strong> — car-relative shots work anywhere.</li>
<li>Click any driver button in the <strong>Live Standings / Contestants</strong> card (or press <code>Alt+1</code>–<code>Alt+9</code>) to aim the camera at them.</li>
<li>Press <strong>Arm (<code>A</code>)</strong>, then <strong>Start Race (<code>S</code>)</strong>; cut between shots with <code>1</code>–<code>9</code> or the shot dropdown. <strong>Panic Stop (<code>X</code>)</strong> works at any moment and restores your normal game view in &lt; 1 s; press <code>A</code> again when you are ready to resume.</li>
</ol>

<h3>2. Loading Any Track — 4 ways, zero Python</h3>
<ul>
<li><strong>Live In-Game Event (1 click):</strong> from the Live Events bar click <strong>Load &amp; Preview</strong> or <strong>Load &amp; Apply selected</strong>. Reads the route directly from the running game, so it works for <code>/setup_event</code> races <em>and</em> native Motor Town events. Tick <strong>Auto-Start on Green Light</strong> and <strong>Follow Race Leader</strong> to let the director follow the action hands-free.</li>
<li><strong>Upload / Drop / Paste JSON:</strong> click <strong>Choose file</strong> to pick a <code>.json</code>/<code>.txt</code> file, drag a file onto the <strong>Track Loader</strong> card (tick <strong>Auto-apply on drop</strong> to load it straight away), paste copied text from Discord into <strong>Paste JSON</strong> (<code>```json</code> fences are stripped automatically), or use <strong>Dropped Files</strong> to load from <code>racecam/inbox/</code> — drop a single file there as <code>drop_event.json</code> and hit Refresh. Accepts full event exports, <code>race_setup</code>, Track Editor routes, bare waypoint arrays, and pre-built <code>{ shots: [...] }</code> plans. The canvas previews the route; <strong>Saved plans</strong> reloads a plan built earlier.</li>
<li><strong>Free-Roam Pin Position:</strong> while driving or teleporting along the route, click <strong>Pin Position</strong> 3+ times (Undo Pin / Clear Pins fix mistakes), then <strong>Build &amp; Load Pins</strong> to generate the whole shot deck on the spot.</li>
<li><strong>Quick Follow (No Track):</strong> press <strong>Arm (<code>A</code>)</strong> right away. The built-in follow/orbit shots are car-relative and work anywhere on the map — no track, file or pins needed.</li>
</ul>

<h3>3. Universal <code>1</code>–<code>9</code> Shot Deck &amp; extra (<code>·</code>) shots</h3>
<div class="kbd">The same nine slots exist on every track so your muscle memory carries between events. On the <strong>Camera Pads</strong> grid click a pad or press its number; each pad shows a keycap badge, a friendly label and a category pill (Track / Follow / Drone / Hero). The active PROGRAM pad glows red, the staged PREVIEW pad glows green.</div>
<ol>
<li><code>start_line</code> — grid / start-line frame; active on arm.</li>
<li><code>fly_up</code> — 4 s rising intro tween to an overhead establishing shot; fired by <code>S</code>.</li>
<li><code>auto_trackside</code> — TV-director mode: picks the next trackside camera and pans/zooms as the car passes.</li>
<li><code>heli_follow</code> — high aerial drone follow for reading racing lines and multi-car battles.</li>
<li><code>follow_focus</code> — tight rear hero chase.</li>
<li><code>front_chase</code> — reverse battle cam looking back at the chasing pack.</li>
<li><code>side_tracking</code> — low parallel dolly for speed, drift and rally close-ups.</li>
<li><code>orbit_hero</code> — smooth 360° orbit around the target; great for grids and podiums.</li>
<li><code>route_flyover</code> — continuous course flyover for pre-race track previews.</li>
</ol>
<div class="kbd">Dropdown-only <code>·</code> shots: <code>finish_line</code> (frames the line), <code>overview</code> (high static course view), broadcast rigs <code>onboard_tcam</code>, <code>rear_battle</code> and <code>pack_battle</code>, auto-placed <code>straight_telephoto</code>, <code>curb_apex</code> and <code>start_crane</code> cameras, and up to six <code>corner_XX_pan</code> cameras that pan and auto-zoom to the followed contestant. Shots past <code>9</code> have no number key — click their pad in the extra row. The <code>#sid</code> dropdown stays available as a compact fallback.</div>

<h3>4. Keyboard Hotkeys <span class="kbd">(when focus is outside text inputs)</span></h3>
<div class="kbd">
<code>A</code> Arm &nbsp;·&nbsp; <code>S</code> Start Race &nbsp;·&nbsp; <code>1</code>–<code>9</code> Camera Slots &nbsp;·&nbsp; <code>Alt+1</code>–<code>Alt+9</code> Switch Contestant &nbsp;·&nbsp; <code>Q</code> Queue shot (type a delay in <strong>At t+</strong> first) &nbsp;·&nbsp; <code>N</code> Fire next queued cue &nbsp;·&nbsp; <code>Z</code> Clear queue &nbsp;·&nbsp; <code>R</code> Toggle Rehearsal &nbsp;·&nbsp; <code>X</code> Panic Stop
</div>
<div class="kbd"><strong>Preview→Take (<code>Space</code>):</strong> toggle the Switching Desk mode button; <code>1</code>–<code>9</code> or a pad click then stages the shot in green <strong>PREVIEW</strong>, and <code>Space</code> (or the <strong>TAKE</strong> button) cuts it to <strong>PROGRAM</strong>. The default <strong>Cut Bus</strong> cuts on the first click. Typing in any field pauses hotkeys — the tally bar shows <code>KEYS PAUSED (Esc)</code>; press <code>Esc</code> to blur the field and restore <code>KEYS ACTIVE</code>.</div>
<div class="kbd">The <strong>Next cue</strong> and <strong>Clear queue</strong> buttons beside the cue queue work even while you are typing in a field. In this panel build <code>Z</code> is also wired to <strong>Last-shot undo</strong>, so use the button when you need to empty the queue mid-show.</div>

<h3>5. Contestants, Automation, Safety/Fail-Safes &amp; OBS</h3>
<ul>
<li><strong>One-click Live Leaderboard:</strong> the contestant card refreshes every 700 ms. Each driver button shows <code>P1</code>/<code>P2</code>/<code>P3</code> (gold/silver/bronze) or <code>DQ</code>, lap/gate progress, best lap and a live gap; the active target gets a green border and a <code>● ON AIR</code> pill. Click a driver (or press <code>Alt+1</code>–<code>Alt+9</code>) to switch targets: this automatically unticks <strong>Follow Race Leader</strong> so auto-follow cannot yank the camera back after your cut — tick it again to re-engage. Off-list names go in <strong>Manual target</strong> then <strong>Lock</strong>.</li>
<li><strong>Automation:</strong> <strong>Auto-Start on Green Light</strong> starts the timed cue sequence when the in-game countdown goes green; <strong>Follow Race Leader</strong> keeps the shot on P1. Both are opt-in — flags are only sent when you tick them.</li>
<li><strong>Target Lost:</strong> if the followed player disconnects or respawns, RaceCam holds the last camera pose, shows a red <code>TARGET LOST</code> banner, and retries the name every 0.5 s. Select another driver or cut to a non-follow shot (<code>1</code>, <code>2</code>, <code>9</code>) to clear it.</li>
<li><strong>Rehearsal (<code>R</code>):</strong> cues and timing run but the live camera does not move. OBS <strong>Start record</strong> is blocked while rehearsal is on; <strong>Stop record</strong> still works so a dry run cannot pollute a real recording.</li>
<li><strong>Safety &amp; fail-safes:</strong> <code>X</code> is the instant Panic Stop. If the browser tab closes or crashes for more than 120 s, the Lua server stops the camera and marks the session <code>DEGRADED</code>; reconnect, read the red banner and press <code>A</code> to re-arm. Watch the status strip for active shot, FOV, plan, countdown, heartbeat age and camera state — and the <code>out</code> log when something looks wrong.</li>
<li><strong>OBS Studio:</strong> enable WebSocket v5 on <code>127.0.0.1:4455</code> with auth, enter the password once in the OBS card, click <strong>Connect</strong> and <strong>Check OBS</strong>, then <strong>Refresh scenes</strong> → <strong>Go to scene</strong> → <strong>Preview</strong>. Turn on Studio Mode in OBS so preview stays isolated from program; Start/Stop record and <strong>Preview</strong> are all controllable from here.</li>
</ul>
</details>
<script>
const $=id=>document.getElementById(id);
let tok=localStorage.getItem('rc_tok')||sessionStorage.getItem('racecam_tok')||'';$('tok').value=tok;
function save(){tok=$('tok').value;try{localStorage.setItem('rc_tok',tok)}catch(e){}try{sessionStorage.setItem('racecam_tok',tok)}catch(e){}}
function hdr(){return tok?{'x-racecam-token':tok}:{}}
let rehearsal=false,shotHist=[],windowDegraded=false,windowTargetLost=false;
/* ---- Camera smoothing preset (tight / normal / cinematic) ----
   The panel is a thin operator surface: Lua owns the time constants, we only
   send the chosen preset and mirror the engine's answer back into the deck. */
const SMOOTHING_MODES=['tight','normal','cinematic'];
let smoothingMode='normal';
function highlightSmoothing(mode){
  SMOOTHING_MODES.forEach(m=>{const el=$('sm_'+m);if(el)el.className='sm-btn'+(m===mode?' on':'')});
}
async function setSmoothing(mode){
  if(SMOOTHING_MODES.indexOf(mode)<0)return null;
  smoothingMode=mode;highlightSmoothing(mode);
  return cmd('smoothing',mode);
}
let smTuneTimer=null,smTuneDirtyAt=0;
function toggleSmoothingTune(){
  const b=$('sm_tune_box');if(!b)return;
  const open=b.style.display==='none';
  b.style.display=open?'':'none';
  const btn=$('sm_tune_btn');if(btn)btn.className='sm-btn'+(open?' on':'');
}
function syncSmoothingCfg(cfg){
  if(!cfg||Date.now()-smTuneDirtyAt<1200)return;
  const set=(id,vid,v)=>{const el=$(id);if(el&&v!=null){el.value=Number(v).toFixed(2);const sp=$(vid);if(sp)sp.textContent=Number(v).toFixed(2)+'s'}};
  set('sm_tau_pos','sm_tau_pos_v',cfg.tau_pos);
  set('sm_tau_hdg','sm_tau_hdg_v',cfg.tau_hdg);
  set('sm_tau_look','sm_tau_look_v',cfg.tau_look);
  set('sm_tau_fov','sm_tau_fov_v',cfg.tau_fov);
  const pr=$('sm_predict');if(pr&&cfg.use_vel_predict!=null)pr.checked=!!cfg.use_vel_predict;
}
async function sendSmoothing(payload){
  try{
    const r=await fetch('/api/smoothing',{method:'POST',headers:Object.assign({'Content-Type':'application/json'},hdr()),body:JSON.stringify(payload)});
    return await r.json();
  }catch(e){return null}
}
function onSmoothingInput(){
  smTuneDirtyAt=Date.now();
  const payload={
    tau_pos:Number($('sm_tau_pos').value),
    tau_hdg:Number($('sm_tau_hdg').value),
    tau_look:Number($('sm_tau_look').value),
    tau_fov:Number($('sm_tau_fov').value),
    use_vel_predict:!!$('sm_predict').checked
  };
  $('sm_tau_pos_v').textContent=payload.tau_pos.toFixed(2)+'s';
  $('sm_tau_hdg_v').textContent=payload.tau_hdg.toFixed(2)+'s';
  $('sm_tau_look_v').textContent=payload.tau_look.toFixed(2)+'s';
  $('sm_tau_fov_v').textContent=payload.tau_fov.toFixed(2)+'s';
  if(smTuneTimer)clearTimeout(smTuneTimer);
  smTuneTimer=setTimeout(()=>sendSmoothing(payload),80);
}
async function resetSmoothingTune(){
  smTuneDirtyAt=0;
  const r=await sendSmoothing({reset:true});
  if(r&&r.smoothing_cfg)syncSmoothingCfg(r.smoothing_cfg);
}

/* ---- Auto Director: Off / Auto Shots / Auto Full ----
   Lua owns every decision; the panel only sends the chosen mode and mirrors
   the live reason / manual-override countdown from /api/state. */
const DIRECTOR_MODES=['off','shots','full'];
let directorMode='off',directorReason='',directorOverrideS=0;
function highlightDirector(mode){
  DIRECTOR_MODES.forEach(m=>{const el=$('dir_'+m);if(el)el.className='sm-btn'+(m===mode?' on':'')});
}
function renderDirBadge(){
  const b=$('dir_badge');if(!b)return;
  if(directorMode==='off'){
    b.style.display='none';b.textContent='';b.className='badge tally-off';return;
  }
  b.style.display='';
  const secs=Math.max(0,Math.round(Number(directorOverrideS)||0));
  if(secs>0){b.textContent='OVERRIDE ('+secs+'s)';b.className='badge tally-on-prev';return}
  const reason=String(directorReason||'');
  b.textContent='AUTO: '+(reason||'idle');
  b.className='badge '+(reason?'tally-on-prog':'tally-off');
}
async function setDirector(mode){
  if(DIRECTOR_MODES.indexOf(mode)<0)return null;
  directorMode=mode;highlightDirector(mode);renderDirBadge();
  return cmd('director',mode);
}

/* ---- Broadcast HUD visibility: Full / Tags Only / Clean ---- */
const HUD_MODES=['full','tags_only','clean'];
const HUD_BTN_IDS={full:'hud_full',tags_only:'hud_tags',clean:'hud_clean'};
let hudMode='full';
function highlightHud(mode){
  HUD_MODES.forEach(m=>{const el=$(HUD_BTN_IDS[m]);if(el)el.className='sm-btn'+(m===mode?' on':'')});
}
async function setHudMode(mode){
  if(HUD_MODES.indexOf(mode)<0)return null;
  hudMode=mode;highlightHud(mode);
  return cmd('hud',mode);
}

/* ---- Broadcast Desk v2: tally, camera pads, preview→take, focus keys ----
   Purely a client-side operator surface. Every action still funnels through
   the unchanged cmd()/trigger()/fetch() API — no new endpoints. */
const SHOT_LABELS={start_line:'Start Line',fly_up:'Fly Up',auto_trackside:'Auto Trackside',
  heli_follow:'Heli Follow',follow_focus:'Follow Focus',front_chase:'Front Chase',
  side_tracking:'Side Track',orbit_hero:'Orbit Hero',route_flyover:'Flyover',
  finish_line:'Finish Line',overview:'Overview',
  onboard_tcam:'Onboard T-Cam',rear_battle:'Rear Battle',pack_battle:'Pack Battle',
  straight_telephoto:'Straight Tele',curb_apex:'Curb Apex',start_crane:'Start Crane'};
let takeMode=false,stagedShot='',lastDeckSig='',lastCueSig='',lastDeckState=null;
let recording=false,recStart=0;
function toast(msg){const t=$('toast');if(t)t.textContent=String(msg===undefined||msg===null?'':msg).slice(0,140)}
function typingEl(el){return !!el&&/INPUT|SELECT|TEXTAREA/.test(String(el.tagName||''))}
function updateKeysPill(){
  const p=$('keys_pill');if(!p)return;
  const paused=typingEl(document.activeElement);
  p.textContent=paused?'KEYS PAUSED (Esc)':'KEYS ACTIVE';
  p.className='pill '+(paused?'keys-paused':'keys-on');
}
function isTakeMode(){return !!takeMode}
function shotLabel(id){return SHOT_LABELS[id]||String(id||'').replace(/_/g,' ')
  .replace(/\b\w/g,c=>c.toUpperCase())}
function shotKind(id){
  if(/^corner_/.test(id))return 'trackside';
  if(id==='straight_telephoto'||id==='curb_apex'||id==='start_crane')return 'trackside';
  if(id==='finish_line'||id==='overview'||id==='orbit_hero')return 'hero';
  if(id==='onboard_tcam'||id==='rear_battle'||id==='pack_battle')return 'follow';
  if(/follow|chase|focus/.test(id))return 'follow';
  if(/heli|fly|drone/.test(id))return 'drone';
  return 'track';
}
/* Click-safe, signature-diffed stream-deck renderer. The nine universal slots
   get keycap badges; everything past slot 9 (finish_line, overview, corners)
   lands in the extra row. PROGRAM = red .pgm, PREVIEW = green .prv. */
function renderShotDeck(state){
  if(state)lastDeckState=state;
  const s=lastDeckState||{};
  const sel=$('sid');
  const fromSel=sel&&sel.options?Array.from(sel.options).map(o=>o.value):[];
  const shots=(Array.isArray(s.shots)&&s.shots.length)?s.shots:fromSel;
  const cur=String(s.current||s.active_shot||'');
  const nx=stagedShot||String(s.next||'');
  const sig=shots.join('|')+'#'+cur+'#'+nx+'#'+(takeMode?'T':'C');
  if(sig===lastDeckSig)return sig;
  lastDeckSig=sig;
  const pad=(id,i)=>{
    const cls=['shot-pad'];
    if(cur&&id===cur)cls.push('pgm');
    if(nx&&id===nx)cls.push('prv');
    const kind=shotKind(id);
    const badge=i<9?('<span class="keycap">'+(i+1)+'</span>'):'<span class="keycap dot">·</span>';
    return '<button type="button" class="'+cls.join(' ')+'" data-rc-shot="'+escHtml(id)+'">'+
      badge+'<span class="pad-label">'+escHtml(shotLabel(id))+'</span>'+
      '<span class="pad-kind '+kind+'">'+kind+'</span>'+
      (cur&&id===cur?'<span class="onair-dot">ON AIR</span>':'')+'</button>';
  };
  $('shot_pads').innerHTML=shots.slice(0,9).map(pad).join('');
  $('shot_pads_extra').innerHTML=shots.slice(9).map((id,j)=>pad(id,j+9)).join('');
  return sig;
}
/* Interactive cue rundown: chips with a quick × remove; the muted Clear queue
   button (cmd('queue_clear')) stays physically separate from Next cue. */
function renderCues(){
  const sig=JSON.stringify(cueList);
  if(sig===lastCueSig)return sig;
  lastCueSig=sig;
  $('q').innerHTML=cueList.map((c,i)=>'<span class="cue-chip"><b>'+(i+1)+'.</b> '+
    escHtml(c&&c.id)+(c&&c.at_t!=null?(' @ t+'+escHtml(c.at_t)+'s'):'')+
    '<button type="button" class="cue-x" data-cue-remove="'+i+'" title="Remove cue">×</button></span>').join('')
    ||'<span class="muted">No cues queued</span>';
  return sig;
}
function stageShot(id){
  if(!id)return null;
  stagedShot=String(id);
  const p=$('prv');if(p){p.className='badge tally-on-prev';p.textContent='PREVIEW '+stagedShot}
  lastDeckSig='';renderShotDeck();
  toast('STAGED '+stagedShot+' — Space / TAKE to cut');
  return stagedShot;
}
function takeShot(){
  if(!takeMode){toast('Switch to Preview→Take first (mode button)');return null}
  if(!stagedShot){toast('No shot staged — press 1–9 first');return null}
  const id=stagedShot;stagedShot='';
  trigger(id);lastDeckSig='';renderShotDeck();
  toast('TAKE '+id);
  return id;
}
function toggleMode(){
  takeMode=!takeMode;stagedShot='';
  const b=$('mode_btn');if(b){b.textContent=takeMode?'Preview→Take':'Cut Bus';b.className='t-mode'+(takeMode?' on':'')}
  const t=$('take_btn');if(t)t.disabled=!takeMode;
  lastDeckSig='';renderShotDeck();
  toast(takeMode?'Preview→Take: 1–9 stages, Space takes':'Cut Bus: 1–9 cuts immediately');
  return takeMode;
}
function toggleFollow(){
  const cb=$('follow_leader');
  if(!cb||cb.disabled){toast('Follow Leader needs an active in-game event');return null}
  cb.checked=!cb.checked;
  const b=$('auto_follow');if(b){b.className='tog'+(cb.checked?' on':'');b.textContent=cb.checked?'✓ Follow Leader':'Follow Leader'}
  return postAutoFlags();
}
function openSetup(){const d=$('drawer_setup');if(d)d.open=true;return d}
function collapseSetup(){const d=$('drawer_setup');if(d)d.open=false;return d}
function toggleConnDrawer(){const d=$('drawer_conn');if(d)d.open=!d.open;return d}
function setAuthPill(){const p=$('auth_pill');if(p){p.textContent=tok?'Auth ✓':'Auth';p.className='pill'+(tok?' ok':'')}}
function setObsPill(t){
  const p=$('obs_pill');if(!p)return;
  const live=/connected|recording|scene set|ready|checking/i.test(String(t||''));
  p.textContent=recording?'OBS ● REC':(live?'OBS LIVE':'OBS OFF');
  p.className='pill '+(!live&&!recording?'':(recording?'rec':'ok'));
}
/* New operator fields are the visible ones; the original IDs remain in the DOM
   as mirrors so every legacy handler/test keeps working unchanged. */
function syncObsAliases(){
  const a=$('obs_url'),b=$('obsurl');if(a&&b&&String(a.value||'').trim())b.value=a.value;
  const p=$('obs_pw'),q=$('obspw');if(p&&q&&String(p.value||''))q.value=p.value;
  const r=$('obs_rem'),s=$('obs_remember');if(r&&s)s.checked=!!r.checked;
  const sc=$('obs_sc'),osc=$('obsscene');if(sc&&osc&&sc.value)osc.value=sc.value;
}
function renderObsScenePads(scenes,current){
  const list=Array.isArray(scenes)?scenes:[];
  const host=$('obs_scene_pads');if(host)host.innerHTML=list.map(sc=>
    '<button type="button" class="scene-pad'+(sc===current?' pgm':'')+'" data-rc-scene="'+escHtml(sc)+'">'+
    escHtml(sc)+'</button>').join('');
  const q=$('obs_quick');if(q)q.style.display=list.length?'':'none';
  return list.length;
}
function toggleRec(){
  recording=!recording;
  if(recording)recStart=Date.now();
  const b=$('rec_btn');if(b)b.className='rec'+(recording?' on':'');
  obsRec(recording);
  return recording;
}

async function toggleRehearsal(){
  const next=!rehearsal;
  const j=await cmd('rehearsal',next?'on':'off');
  if(j&&j.status&&j.status.indexOf('on')>=0)rehearsal=true;
  else if(j&&j.status&&j.status.indexOf('off')>=0)rehearsal=false;
  $('rehb').textContent=rehearsal?'ON':'OFF';
  const rb=$('reh_btn');if(rb){rb.textContent=rehearsal?'REHEARSAL ON (R)':'REHEARSAL (R)';rb.className='pill'+(rehearsal?' rec':'')}
  banner();
}
function banner(){
  const b=$('banner');b.className='';b.textContent='';
  const deg=$('deg'),reh=$('reh');
  if(deg){deg.className='alert deg';deg.textContent=''}
  if(reh){reh.className='alert reh';reh.textContent=''}
  if(windowDegraded){b.className='degraded';b.textContent='DEGRADED — operator heartbeat lost, shots stopped. Press Arm (A), then Start (S) to resume.';if(deg){deg.className='alert deg on';deg.textContent=b.textContent}}
  else if(windowTargetLost){b.className='degraded';b.textContent='TARGET LOST — followed player not found; holding last camera pose.';if(deg){deg.className='alert deg on';deg.textContent=b.textContent}}
  else if(rehearsal){b.className='rehearsal';b.textContent='REHEARSAL — camera and OBS record commands are suppressed';if(reh){reh.className='alert reh on';reh.textContent=b.textContent}}
}
async function cmd(c,a){
  try{
    let r=await fetch('/api/command',{method:'POST',headers:Object.assign({'content-type':'application/json'},hdr()),body:JSON.stringify({cmd:c,args:a||''})});
    let j=await r.json();
    $('out').textContent=JSON.stringify(j)+'\n'+$('out').textContent;
    toast((j&&j.status)?j.status:(c+' ok'));
    return j;
  }catch(e){$('out').textContent='ERR '+e+'\n'+$('out').textContent;toast('ERR '+e)}
}
let cueList=[];
function trigger(id){if(!id)return;shotHist.push(id);if(shotHist.length>50)shotHist.shift();cmd('trigger',id)}
function enqueue(){
  const id=$('sid').value.trim(); if(!id)return;
  const at=$('qat').value.trim();
  const cue=at?{id:id,at_t:parseFloat(at)}:{id:id};
  cueList.push(cue);
  cmd('queue',JSON.stringify(cueList));
  renderCues();
  $('qat').value='';
}
function undo(){shotHist.pop();const p=shotHist[shotHist.length-1];if(p)cmd('trigger',p);else cmd('stop')}
/* ---- Live leaderboard / 1-click contestant targeting ---- */
let lastState=null,lastRosterSig=null,rosterNames=[];
function escHtml(s){return String(s===undefined||s===null?'':s).replace(/&/g,'&amp;')
  .replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;')}
function fmtBest(sec){
  const v=Number(sec);
  if(!isFinite(v)||v<=0)return '';
  const m=Math.floor(v/60),r=v-m*60;
  return m+':'+(r<10?'0':'')+r.toFixed(1);
}
function rcStatus(sd){
  if(sd.in_countdown)return 'COUNTDOWN';
  const st=Number(sd.state);
  if(st===3)return 'FINISHED';
  if(st===2)return 'RACING';
  if(st===1)return 'COUNTDOWN';
  return 'LOBBY';
}
function rcProgress(row,numLaps,wpCount){
  if(row.finished)return 'FIN';
  if(row.disqualified)return 'DQ';
  const laps=Number(row.laps)||0,sec=Number(row.section)||0;
  const lapPart=numLaps>0?('L'+laps+'/'+numLaps+' · '):'';
  return lapPart+'G'+sec+(wpCount>0?('/'+wpCount):'');
}
function rcGap(row,p1){
  if(!p1||row.disqualified||row.finished)return '';
  if((Number(row.rank)||0)<=1)return '';
  if((Number(row.laps)||0)!==(Number(p1.laps)||0))return '';
  if((Number(row.section)||0)!==(Number(p1.section)||0))return '';
  const d=(Number(row.last_sec_s)||0)-(Number(p1.last_sec_s)||0);
  return d>0?('+'+d.toFixed(1)+'s'):'';
}
function rcPos(row){
  if(row.disqualified)return {label:'DQ',cls:'dq'};
  const rank=Number(row.rank)||0;
  if(rank<=0)return {label:'—',cls:''};
  return {label:'P'+rank,cls:rank===1?'p1':(rank===2?'p2':(rank===3?'p3':''))};
}
function onAirPill(on){return on?' <span class="onair-pill">● ON AIR</span>':''}
/* Click-safe: only touch the DOM when the compact signature actually changes.
   700 ms polls must never replace a button under the producer's cursor. */
function renderContestants(state){
  if(state)lastState=state;
  const s=state||lastState||{};
  const sd=s.standings;
  const eventMode=!!sd&&Array.isArray(sd.standings)&&sd.standings.length>0;
  const target=String(s.target_name||'');
  let headerText,headerHtml,cls,html,sig;
  if(eventMode){
    const numLaps=Number(sd.num_laps)||0,wpCount=Number(sd.waypoint_count)||0;
    const status=rcStatus(sd),evName=String(sd.event_name||'Live Event');
    const statusCls=status==='COUNTDOWN'?'counting':(status==='RACING'?'racing':(status==='FINISHED'?'finished':''));
    headerText=evName+' · '+(numLaps>0?('Laps: '+numLaps):'Point-to-Point')+' · '+status;
    headerHtml=escHtml(evName)+' · '+(numLaps>0?('Laps: '+numLaps):'Point-to-Point')+
      '<span class="status-pill '+statusCls+'">'+status+'</span>';
    cls='roster';
    const rows=sd.standings;
    const p1=rows.find(r=>!r.disqualified&&Number(r.rank)===1)||rows[0];
    let out='';
    sig=['event',headerText];
    rosterNames=[];
    rows.forEach(row=>{
      const name=String(row.name||''),onAir=name===target,pos=rcPos(row);
      const bits=[],best=fmtBest(row.best_lap_s),gap=rcGap(row,p1);
      if(best)bits.push(best);
      if(gap)bits.push(gap);
      const tele=rcProgress(row,numLaps,wpCount)+(bits.length?(' · '+bits.join(' · ')):'');
      rosterNames.push(name);
      sig.push([pos.label,name,row.laps,row.section,row.best_lap_s,row.last_sec_s,
                !!row.finished,!!row.disqualified,onAir].join('|'));
      out+='<button type="button" class="rc-driver'+(onAir?' onair':'')+'" data-rc-target="'+escHtml(name)+'">'+
        '<span class="rc-pos '+pos.cls+'">'+pos.label+'</span>'+
        '<span class="rc-name">'+escHtml(name)+onAirPill(onAir)+'</span>'+
        '<span class="rc-tele">'+escHtml(tele)+'</span></button>';
    });
    html=out;
  }else{
    const targets=Array.isArray(s.targets)?s.targets:[];
    headerText=targets.length?'Live Vehicles (click to target)':'No vehicles detected';
    headerHtml=escHtml(headerText);
    cls='roster standalone';
    let out='';
    sig=['standalone',headerText];
    rosterNames=[];
    targets.forEach(t=>{
      const name=String(t||''),onAir=name===target;
      rosterNames.push(name);
      sig.push(name+'|'+onAir);
      out+='<button type="button" class="rc-driver'+(onAir?' onair':'')+'" data-rc-target="'+escHtml(name)+'">'+
        '<span class="rc-name">'+escHtml(name)+onAirPill(onAir)+'</span></button>';
    });
    html=out;
  }
  const fullSig=sig.join('~');
  if(fullSig===lastRosterSig)return fullSig;
  lastRosterSig=fullSig;
  $('standings_hdr').innerHTML=headerHtml;
  const el=$('contestants');el.className=cls;el.innerHTML=html;
  return fullSig;
}
async function setTargetByName(name){
  name=String(name===undefined||name===null?'':name).trim();
  if(!name)return null;
  const fl=$('follow_leader');
  if(fl&&fl.checked){fl.checked=false;try{await postAutoFlags()}catch(e){}}
  if(lastState){lastState.target_name=name;renderContestants(lastState)}
  try{
    const r=await fetch('/api/target',{method:'POST',
      headers:Object.assign({'content-type':'application/json'},hdr()),
      body:JSON.stringify({name:name})});
    const j=await r.json();
    $('out').textContent='TARGET '+name+' → '+JSON.stringify(j)+'\n'+$('out').textContent;
    return j;
  }catch(e){$('out').textContent='TARGET ERR '+e+'\n'+$('out').textContent;return null}
}
function lockTyped(){const n=$('tgt_name').value.trim();return n?setTargetByName(n):null}
document.addEventListener('keydown',e=>{
  const t=(e.target&&e.target.tagName)||'';
  // Esc releases any focused field at once so 1-9 / A / S / X work again.
  if(e.key==='Escape'||e.key==='Esc'){
    const a=document.activeElement;
    if(a&&a.blur&&typingEl(a))a.blur();
    updateKeysPill();
    return;
  }
  if(/INPUT|SELECT|TEXTAREA/.test(t))return;
  const k=e.key.toLowerCase();
  // Alt+1..9 cut the target without stealing the 1..9 camera shot slots.
  if(e.altKey&&!e.ctrlKey&&!e.metaKey&&e.key>='1'&&e.key<='9'){
    const name=rosterNames[+k-1];
    if(name){e.preventDefault();setTargetByName(name)}
    return;
  }
  if(e.altKey)return;                        // any other Alt combo is not a camera slot
  if(k==='a')cmd('arm');
  else if(k==='s')cmd('start');
  else if(k==='x')cmd('stop');
  else if(k==='n')cmd('next');
  else if(k==='q')enqueue();
  else if(k==='z')undo();
  else if(k==='r')toggleRehearsal();
  else if(k===' '||e.code==='Space'){if(takeMode){e.preventDefault();takeShot()}}
  else if(/^[1-9]$/.test(k)){
    const o=$('sid').options[+k-1];
    if(o){if(takeMode)stageShot(o.value);else trigger(o.value)}
  }
});

async function poll(){
  try{
    let s=await(await fetch('/api/state',{headers:hdr()})).json();
    windowDegraded=!!s.degraded;
    windowTargetLost=!!s.target_lost;
    const sMode=SMOOTHING_MODES.indexOf(s.smoothing)>=0?s.smoothing:'normal';
    smoothingMode=sMode;highlightSmoothing(sMode);
    if(s.smoothing_cfg)syncSmoothingCfg(s.smoothing_cfg);
    directorMode=DIRECTOR_MODES.indexOf(s.director_mode)>=0?s.director_mode:'off';
    directorReason=String(s.director_reason||'');
    directorOverrideS=Number(s.director_override_s)||0;
    highlightDirector(directorMode);renderDirBadge();
    const hMode=HUD_MODES.indexOf(s.hud_mode)>=0?s.hud_mode:'full';
    hudMode=hMode;highlightHud(hMode);
    if(s.rehearsal!=null&&s.rehearsal!==rehearsal){rehearsal=!!s.rehearsal;$('rehb').textContent=rehearsal?'ON':'OFF'}
    banner();
    const cur=s.current||s.active_shot||'none';
    $('shot').textContent=cur;
    $('fov').textContent=(s.fov!=null)?s.fov:'—';
    $('plan').textContent=s.plan||'—';
    $('cd').textContent=(s.countdown!=null)?Number(s.countdown).toFixed(1)+'s':'—';
    $('hb').textContent=(s.heartbeat_age!=null)?s.heartbeat_age+'s':'—';
    $('run').textContent=(s.running===true)?'ARMED':(s.running===false?'STOPPED':'—');
    $('prog').className='badge '+(cur&&cur!=='none'?'tally-on-prog':'tally-off');
    $('prog').textContent='PROGRAM '+cur;
    $('prv').className='badge '+(s.next&&s.next!=='none'?'tally-on-prev':'tally-off');
    $('prv').textContent='PREVIEW '+(s.next||'—');
    if(s.queue_spec){try{cueList=Array.isArray(s.queue_spec)?s.queue_spec:JSON.parse(s.queue_spec)}catch(e){}}
    $('queue').textContent=(s.queue&&s.queue.length)?s.queue.join(' → '):'—';
    if(s.shots&&s.shots.length){
      const keep=$('sid').value;
      $('sid').innerHTML='';
      s.shots.forEach((shot,i)=>{let o=document.createElement('option');o.value=shot;o.textContent=(i<9?(i+1)+'. ':'· ')+shot;$('sid').appendChild(o)});
      if([...$('sid').options].some(o=>o.value===keep))$('sid').value=keep;
    }
    // Broadcast Desk v2: live tally mirrors, pads and interactive cue chips.
    const pg=$('pgm');if(pg){pg.className='badge '+(cur&&cur!=='none'?'tally-on-prog':'tally-off');pg.textContent='PROGRAM '+(cur&&cur!=='none'?cur:'—')}
    if(stagedShot){$('prv').className='badge tally-on-prev';$('prv').textContent='PREVIEW '+stagedShot}
    const ap=$('arm_pill');if(ap){const on=s.running===true;ap.textContent=on?'ARMED':'STANDBY';ap.className='pill '+(on?'armed':'standby')}
    const tn=$('tgt_name');if(tn&&document.activeElement!==tn&&s.target_name)tn.value=s.target_name;
    const rb=$('reh_btn');if(rb){rb.textContent=rehearsal?'REHEARSAL ON (R)':'REHEARSAL (R)';rb.className='pill'+(rehearsal?' rec':'')}
    if(recording){const sec=Math.floor((Date.now()-recStart)/1000);const mm=String(Math.floor(sec/60)).padStart(2,'0'),ss=String(sec%60).padStart(2,'0');const rt=$('rec_time');if(rt)rt.textContent=mm+':'+ss}
    setObsPill($('obsst').textContent);
    renderShotDeck(s);
    renderCues();
    renderContestants(s);
  }catch(e){}
  if((++pollTick%30)===0)refreshInbox();   // inbox can change while the panel is open
  setTimeout(poll,700);
}

/* ---- routePlanner: exact deterministic port of amc-racecam/route_to_shots.py ----
   Pure JS: no DOM, no fetch, no Python. Accepts RaceSetup JSON, track-editor
   JSON, and live-event payloads. Produces the universal 1-9 shot deck plus
   finish_line, overview, corner_XX_pan cameras and a polyline route export. */
const EPS=1e-9;
function pyRound(v,nd){
  if(!Number.isFinite(v))return v;
  const neg=v<0,s=Math.abs(v).toFixed(17),dot=s.indexOf('.');
  const ip=s.slice(0,dot),fp=s.slice(dot+1),keep=fp.slice(0,nd),rest=fp.slice(nd);
  let k=parseInt((ip+keep)||'0',10),up=false;
  if(rest){
    if(rest[0]>'5')up=true;
    else if(rest[0]==='5')up=(rest.slice(1).replace(/0/g,'')!=='')?true:(k%2===1);
  }
  if(up)k++;
  const out=k/Math.pow(10,nd);
  return neg?-out:out;
}
const round3=v=>pyRound(v,3);
const sub=(a,b)=>[a[0]-b[0],a[1]-b[1],a[2]-b[2]];
const addv=(a,b)=>[a[0]+b[0],a[1]+b[1],a[2]+b[2]];
const scalev=(a,k)=>[a[0]*k,a[1]*k,a[2]*k];
function normXY(a){const m=Math.hypot(a[0],a[1]);if(m<=EPS)throw new Error('degenerate XY vector');return [a[0]/m,a[1]/m,0.0]}
const leftNormal=d=>[-d[1],d[0],0.0];
const rightNormal=d=>[d[1],-d[0],0.0];
const prevIdx=(i,n)=>((i-1)%n+n)%n;
/* A corner's outside is the side away from its turn centre. With
   crossZ = d_in x d_out > 0 the centre sits on leftNormal(d_in), so the
   camera must go on rightNormal(d_in); for crossZ < 0 the reverse holds. */
function outsideNormal(points,i){
  const n=points.length;
  const dIn=normXY(sub(points[i],points[prevIdx(i,n)]));
  const dOut=normXY(sub(points[(i+1)%n],points[i]));
  const crossZ=dIn[0]*dOut[1]-dIn[1]*dOut[0];
  return crossZ>0?rightNormal(dIn):leftNormal(dIn);
}
function directionAt(points,i){
  const n=points.length;if(n<2)throw new Error('need at least 2 waypoints');
  let out=sub(points[(i+1)%n],points[i]);
  if(Math.hypot(out[0],out[1])<=EPS)out=sub(points[i],points[prevIdx(i,n)]);
  return normXY(out);
}
function turnAngle(points,i){
  const n=points.length;if(n<3)return 0.0;
  const a=normXY(sub(points[i],points[prevIdx(i,n)]));
  const b=normXY(sub(points[(i+1)%n],points[i]));
  return Math.acos(Math.max(-1.0,Math.min(1.0,a[0]*b[0]+a[1]*b[1])))*180/Math.PI;
}
const distXY=(a,b)=>Math.hypot(b[0]-a[0],b[1]-a[1]);
function isClosedLoop(points){
  const n=points.length;if(n<3)return false;
  let total=0;for(let i=0;i<n-1;i++)total+=distXY(points[i],points[(i+1)%n]);
  const avg=total/(n-1);
  return distXY(points[0],points[n-1])<=Math.max(3000.0,2.0*avg);
}
/* Generic, case/underscore-insensitive helpers for the universal normalizer.
   canonKey collapses case and separators: race_setup -> racesetup,
   RouteName -> routename, scale3D -> scale3d. */
function canonKey(k){return String(k===null||k===undefined?'':k).toLowerCase().replace(/[_-]/g,'')}
function isObj(v){return v!==null&&typeof v==='object'&&!Array.isArray(v)}
function keyByCanon(o,want){
  for(const k of Object.keys(o))if(canonKey(k)===want)return [k,o[k]];
  return [null,undefined];
}
function pickName(o){
  for(const want of ['routename','eventname','racename','name']){
    const kv=keyByCanon(o,want);
    if(kv[0]!==null&&kv[1]!==undefined&&kv[1]!==null&&String(kv[1]).trim())return String(kv[1]).trim();
  }
  return null;
}
function waypointArray(o){
  const kv=keyByCanon(o,'waypoints');
  return Array.isArray(kv[1])?kv[1]:null;
}
function unwrapChild(o){
  for(const want of ['event','data','config','racesetup','route','raceconfig','racesettings']){
    const kv=keyByCanon(o,want);
    if(kv[0]!==null&&(isObj(kv[1])||Array.isArray(kv[1])))return kv[1];
  }
  return null;
}
function vecOf(d,names){
  if(Array.isArray(d)){
    if(d.length<2)throw new Error('waypoint tuple needs x,y');
    return [Number(d[0])||0.0,Number(d[1])||0.0,Number(d[2])||0.0];
  }
  if(!isObj(d))throw new Error('waypoint is not an object');
  for(const k of names){
    if(k in d&&isObj(d[k])){
      const c=d[k];
      const pick=(...ks)=>{for(const kk of ks)if(kk in c)return Number(c[kk]);return 0.0};
      return [pick('X','x'),pick('Y','y'),pick('Z','z')];
    }
  }
  const pick=(...ks)=>{for(const kk of ks)if(kk in d)return Number(d[kk]);return 0.0};
  if(('X' in d)||('Y' in d)||('Z' in d)||('x' in d)||('y' in d)||('z' in d)){
    return [pick('X','x'),pick('Y','y'),pick('Z','z')];
  }
  throw new Error('no location key in waypoint');
}
function gateOf(wp){
  const g=keyByCanon(wp,'gatem');
  if(g[0]!==null&&g[1]!==undefined&&g[1]!==null)return Number(g[1]);
  const sc=keyByCanon(wp,'scale3d')[1];
  const c=isObj(sc)?sc:{};
  const sy=('Y' in c)?c.Y:(('y' in c)?c.y:undefined);
  return sy!==undefined?Number(sy):18;
}
function parseRoute(doc,nameHint){
  let d=doc,name=null,raw=null;
  for(let depth=0;depth<12&&d!==null&&d!==undefined;depth++){
    if(Array.isArray(d)){raw=d;break}
    if(!isObj(d))throw new Error('route JSON must be an object or array');
    const n=pickName(d);if(n&&!name)name=n;
    const w=waypointArray(d);if(w){raw=w;break}
    const child=unwrapChild(d);
    if(!child)break;
    d=child;
  }
  if(!Array.isArray(raw)||!raw.length)throw new Error('no waypoints found');
  if(!name)name=(nameHint!==undefined&&nameHint!==null&&String(nameHint).trim())?String(nameHint).trim():'unnamed route';
  const points=[],gates=[];
  for(const wp of raw){
    points.push(vecOf(wp,['Location','location','Translation','translation']));
    gates.push(gateOf(wp));
  }
  return {name:name,points:points,gates:gates};
}
function sanitizeId(s){
  const t=String(s===undefined||s===null?'':s).trim().replace(/\.(json|txt)$/i,'');
  const out=t.replace(/[^A-Za-z0-9_-]+/g,'_').replace(/^_+|_+$/g,'');
  return out||'dropped_track';
}
function stripFences(s){
  let t=String(s===undefined||s===null?'':s).trim();
  t=t.replace(/^```[A-Za-z0-9_.+-]*[ \t]*\r?\n?/,'');
  t=t.replace(/\r?\n?```[ \t]*$/,'');
  return t.trim();
}
function firstText(){
  for(let i=0;i<arguments.length;i++){
    const v=arguments[i];
    if(v!==undefined&&v!==null&&String(v).trim())return String(v).trim();
  }
  return '';
}
/* Universal input normalizer for every non-`/setup_event` source.
   Accepts raw text (Discord fenced or plain), any event/route wrapper,
   bare waypoint arrays/tuples, and pre-built RaceCam shot plans. */
function parseAnyInput(rawText,nameHint){
  const text=stripFences(rawText);
  let doc;
  try{doc=JSON.parse(text)}catch(e){throw new Error('invalid JSON: '+e.message)}
  if(!doc||typeof doc!=='object')throw new Error('JSON must be an object or array');
  if(isObj(doc)&&Array.isArray(doc.shots)&&doc.shots.length>0){
    const pid=firstText(doc.plan_id,doc.planId,doc.id,doc.name,nameHint,'custom_plan');
    return {mode:'prebuilt_plan',plan_id:sanitizeId(pid),plan:doc,route:doc.route||null};
  }
  const parsed=parseRoute(doc,nameHint);
  const pid=firstText(nameHint,parsed.name,'dropped_track');
  const plan=buildShots(parsed.name,parsed.points,parsed.gates,{tracksideStride:'auto'});
  return {mode:'route',plan_id:sanitizeId(pid),parsed:parsed,plan:plan,
          route:fallbackRouteExport(parsed.points)};
}
function lookAtShot(sid,loc,at,fov,triggerObj,holdMs){
  const s={id:sid,kind:'look_at',trigger:triggerObj||{type:'manual'},
    location:loc.map(round3),look_at:at.map(round3),fov:fov};
  if(holdMs)s.hold_ms=holdMs;
  return s;
}
function followShot(sid,preset,fov){
  const s={id:sid,kind:'follow',trigger:{type:'manual'},target:'focus',preset:preset};
  if(fov!=null)s.fov=fov;
  return s;
}
function makeCornerCam(points,gates,i,sample){
  const dOut=normXY(sub(points[(i+1)%points.length],points[i]));
  let half=(gates[i]*100.0)/2.0;
  sample=sample||null;
  if(sample&&sample.kind!=='gap'&&sample.lane_width){
    half=Number(sample.lane_width)/2.0;
  }
  /* Outside of the corner, not the inside exit: see outsideNormal(). */
  const outer=outsideNormal(points,i);
  const loc=addv(addv(addv(points[i],scalev(outer,half+500.0)),scalev(dOut,400.0)),[0,0,240.0]);
  const at=addv(points[i],scalev(dOut,800.0));
  return {id:'corner_'+(i<10?'0'+i:i)+'_pan',kind:'trackside_pan',role:'trackside',
    trigger:{type:'manual'},location:loc.map(round3),look_at:at.map(round3),
    fov:45.0,auto_zoom:true,fov_min:13.0,fov_max:58.0};
}
/* Legacy export name kept so any saved plan/tooling calling cornerShot still works. */
const cornerShot=makeCornerCam;
function longestStraightIndex(points){
  const n=points.length;if(n<2)return 0;
  const limit=isClosedLoop(points)?n:n-1;
  let bestK=0,bestD=-1;
  for(let k=0;k<limit;k++){
    const d=distXY(points[k],points[(k+1)%n]);
    if(d>bestD){bestD=d;bestK=k}
  }
  return bestK;
}
function sharpestCornerIndex(points){
  const n=points.length;
  if(n<3)return 0;                    // no interior corners on an open 2-point leg
  let bestI=1,bestA=-1;
  for(let i=1;i<n-1;i++){             // skip the closure duplicate at index 0 / n-1
    const a=turnAngle(points,i);
    if(a>bestA){bestA=a;bestI=i}
  }
  return bestI;
}
/* Three 100% track-general broadcast cameras: telephoto down the longest
   straight, low curb-level view of the sharpest apex, and a start/finish jib. */
function buildSpecialtyShots(points,gates,opts){
  opts=opts||{};
  const n=points.length;if(n<2)return [];
  const sideMarginCm=opts.sideMarginCm!==undefined?opts.sideMarginCm:350.0;
  const k=longestStraightIndex(points),a=points[k],b=points[(k+1)%n];
  let dSeg;
  try{dSeg=normXY(sub(b,a))}catch(e){dSeg=directionAt(points,k)}
  const at90=addv(a,scalev(sub(b,a),0.9));
  const straightLoc=addv(addv(at90,scalev(leftNormal(dSeg),450.0)),[0,0,220.0]);
  const straight={id:'straight_telephoto',kind:'trackside_pan',role:'trackside',
    trigger:{type:'manual'},location:straightLoc.map(round3),look_at:a.map(round3),
    fov:35.0,auto_zoom:true,fov_min:12.0,fov_max:46.0};
  const ci=sharpestCornerIndex(points);
  const dOut=normXY(sub(points[(ci+1)%n],points[ci]));
  const outer=outsideNormal(points,ci);
  const curbLoc=addv(addv(points[ci],scalev(outer,320.0)),[0,0,55.0]);
  const curbAt=addv(points[ci],scalev(dOut,600.0));
  const curb={id:'curb_apex',kind:'trackside_pan',role:'trackside',
    trigger:{type:'manual'},location:curbLoc.map(round3),look_at:curbAt.map(round3),
    fov:62.0,auto_zoom:true,fov_min:24.0,fov_max:72.0};
  const d0=directionAt(points,0),nn0=leftNormal(d0),halfGate=(gates[0]*100.0)/2.0;
  const craneLoc=addv(addv(addv(points[0],scalev(d0,-800.0)),
    scalev(nn0,halfGate+sideMarginCm+400.0)),[0,0,1400.0]);
  const craneAt=addv(points[0],scalev(d0,600.0));
  const crane={id:'start_crane',kind:'trackside_pan',role:'trackside',
    trigger:{type:'manual'},location:craneLoc.map(round3),look_at:craneAt.map(round3),
    fov:48.0,auto_zoom:true,fov_min:18.0,fov_max:56.0};
  return [straight,curb,crane];
}
function rankCorners(points,maxTrackside){
  if(maxTrackside===undefined)maxTrackside=6;
  const n=points.length,minSep=Math.max(1,Math.floor(n/(maxTrackside+1))),cands=[];
  for(let i=1;i<n-1;i++){
    const dz=Math.abs(points[(i+1)%n][2]-points[prevIdx(i,n)][2]);
    cands.push({score:turnAngle(points,i)+0.05*dz,i:i});
  }
  cands.sort((a,b)=>(b.score-a.score)||(a.i-b.i));
  const picked=[];
  for(const c of cands){
    if(picked.every(j=>Math.abs(c.i-j)>=minSep))picked.push(c.i);
    if(picked.length>=maxTrackside)break;
  }
  return picked.sort((a,b)=>a-b);
}
function buildShots(name,points,gates,opts){
  opts=opts||{};
  let tracksideStride=opts.tracksideStride!==undefined?opts.tracksideStride:(opts.trackside_stride!==undefined?opts.trackside_stride:5);
  if(tracksideStride===null||tracksideStride==='auto'||!tracksideStride){
    tracksideStride=Math.max(2,pyRound(points.length/4.0,0));
  }
  tracksideStride=Math.max(1,Math.trunc(tracksideStride));
  const startBackCm=opts.startBackCm!==undefined?opts.startBackCm:1200.0;
  const sideMarginCm=opts.sideMarginCm!==undefined?opts.sideMarginCm:350.0;
  const tracksideHeightCm=opts.tracksideHeightCm!==undefined?opts.tracksideHeightCm:250.0;
  const overheadCm=opts.overheadCm!==undefined?opts.overheadCm:5500.0;
  const fovStart=opts.fovStart!==undefined?opts.fovStart:55.0;
  const fovAir=opts.fovAir!==undefined?opts.fovAir:85.0;
  const fovSide=opts.fovSide!==undefined?opts.fovSide:70.0;
  const routeExport=opts.routeExport!==undefined?opts.routeExport:(opts.route_export!==undefined?opts.route_export:null);
  const maxTrackside=opts.maxTrackside!==undefined?opts.maxTrackside:(opts.max_trackside!==undefined?opts.max_trackside:6);
  const n=points.length;
  const closed=isClosedLoop(points);
  const d0=directionAt(points,0),nn0=leftNormal(d0),halfGate=(gates[0]*100.0)/2.0;
  // Front-on centerline shot looking back down the starting grid so pit
  // buildings, barriers, and grandstands on the sides never block the view.
  const startAheadCm=opts.startAheadCm!==undefined?opts.startAheadCm:1800.0;
  const startLoc=addv(addv(points[0],scalev(d0,startAheadCm)),[0,0,420.0]);
  const startAt=addv(addv(points[0],scalev(d0,-600.0)),[0,0,120.0]);
  const fromPose={location:startLoc,look_at:startAt,fov:fovStart};
  const toPose={location:addv(addv(points[0],[0,0,overheadCm]),scalev(nn0,-400.0)),
    look_at:addv(points[0],scalev(d0,1000.0)),fov:fovAir};
  const shots=[
    lookAtShot('start_line',startLoc,startAt,fovStart,{type:'boot'}),
    {id:'fly_up',kind:'tween',trigger:{type:'event_start'},duration_ms:4000,
      ease:'ease_in_out_cubic',hold_ms:1500,from:fromPose,to:toPose},
    {id:'auto_trackside',kind:'auto_trackside',trigger:{type:'manual'}},
    followShot('heli_follow','heli_follow',55.0),
    followShot('follow_focus','chase_close',70.0),
    followShot('front_chase','front_chase',65.0),
    followShot('side_tracking','side_tracking',68.0),
    {id:'orbit_hero',kind:'orbit',trigger:{type:'manual'},target:'focus',preset:'orbit_hero',fov:60.0},
    {id:'route_flyover',kind:'flyover',trigger:{type:'manual'},preset:'route_flyover',fov:76.0}
  ];
  const splineSample=i=>{
    if(!routeExport)return null;
    const projs=routeExport.waypoint_projection_cm||[];
    if(i>=projs.length)return null;
    const target=Number(projs[i]);
    let best=null,bestD=Infinity;
    for(const s of (routeExport.samples||[])){
      const dd=Math.abs(Number(s.dist||0.0)-target);
      if(dd<bestD){best=s;bestD=dd}
    }
    return best;
  };
  // Front-on centerline finish shot: sits past the finish line on the road
  // centerline looking back at oncoming cars so side structures cannot block.
  const finAnchor=closed?points[0]:points[n-1];
  const finDir=closed?d0:normXY(addv(points[n-1],scalev(points[Math.max(0,n-2)],-1)));
  const finishLoc=addv(addv(finAnchor,scalev(finDir,1800.0)),[0,0,420.0]);
  const finishTarget=addv(addv(finAnchor,scalev(finDir,-800.0)),[0,0,120.0]);
  shots.push(lookAtShot('finish_line',finishLoc,finishTarget,fovSide));
  let cx=0,cy=0,cz=0;
  for(const p of points){cx+=p[0];cy+=p[1];cz+=p[2]}
  cx/=n;cy/=n;cz/=n;
  shots.push({id:'overview',kind:'look_at',trigger:{type:'manual'},
    location:[round3(cx),round3(cy),round3(cz+overheadCm)],
    look_at:[round3(cx),round3(cy),round3(cz)],fov:fovAir});
  shots.push(
    {id:'onboard_tcam',kind:'follow',trigger:{type:'manual'},target:'focus',preset:'onboard_tcam',fov:78.0},
    {id:'rear_battle',kind:'follow',trigger:{type:'manual'},target:'focus',preset:'rear_battle',fov:68.0},
    {id:'pack_battle',kind:'pack_battle',trigger:{type:'manual'},target:'focus',preset:'pack_battle',fov:68.0});
  for(const s of buildSpecialtyShots(points,gates,{sideMarginCm:sideMarginCm}))shots.push(s);
  for(const i of rankCorners(points,maxTrackside)){
    shots.push(makeCornerCam(points,gates,i,splineSample(i)));
  }
  return {schema:1,name:name,source:{route:name,waypoints:n,closed_loop:closed},units:'cm',shots:shots};
}
function fallbackRouteExport(points,stepCm){
  if(stepCm===undefined)stepCm=2500.0;
  const n=points.length,closed=isClosedLoop(points),chain=points.slice();
  if(closed&&distXY(points[0],points[n-1])>1.0)chain.push(points[0]);
  const samples=[];let dist=0;
  for(let i=0;i<chain.length-1;i++){
    const a=chain[i],b=chain[i+1],seg=distXY(a,b);
    const heading=Math.atan2(b[1]-a[1],b[0]-a[0]);
    const steps=Math.max(1,Math.ceil(seg/stepCm));
    for(let k=0;k<steps;k++){
      const t=k/steps;
      samples.push({dist:round3(dist+seg*t),x:round3(a[0]+(b[0]-a[0])*t),
        y:round3(a[1]+(b[1]-a[1])*t),z:round3(a[2]+(b[2]-a[2])*t),heading:pyRound(heading,6)});
    }
    dist+=seg;
  }
  samples.push({dist:round3(dist),x:round3(chain[chain.length-1][0]),
    y:round3(chain[chain.length-1][1]),z:round3(chain[chain.length-1][2]),
    heading:samples.length?samples[samples.length-1].heading:0.0});
  return {samples:samples,total_length_cm:round3(dist),closed_loop:closed};
}
window.routePlanner={parseRoute:parseRoute,parseAnyInput:parseAnyInput,sanitizeId:sanitizeId,
  isClosedLoop:isClosedLoop,directionAt:directionAt,
  leftNormal:leftNormal,rightNormal:rightNormal,outsideNormal:outsideNormal,
  turnAngle:turnAngle,rankCorners:rankCorners,buildShots:buildShots,
  fallbackRouteExport:fallbackRouteExport,normXY:normXY,distXY:distXY,round3:round3,pyRound:pyRound,
  sub:sub,add:addv,scale:scalev,cornerShot:cornerShot,makeCornerCam:makeCornerCam,
  buildSpecialtyShots:buildSpecialtyShots,longestStraightIndex:longestStraightIndex,
  sharpestCornerIndex:sharpestCornerIndex,lookAtShot:lookAtShot,followShot:followShot};

/* ---- Live events / track loader / 2D preview ---- */
let liveEvents=[],currentParsed=null,currentPoints=null,currentGates=null,currentRoute=null;
let currentTrackName='';
let pins=[],currentPlanId=null,pollTick=0;
function note(s){$('track_info').textContent=s}
async function refreshLiveEvents(){
  try{
    const j=await(await fetch('/api/live_events',{headers:hdr()})).json();
    liveEvents=Array.isArray(j.events)?j.events:[];
    renderLiveEvents();
    return liveEvents;
  }catch(e){liveEvents=[];renderLiveEvents();return []}
}
function currentLiveEvent(){return liveEvents.find(e=>e.is_member===true)||null}
function renderLiveEvents(){
  const cur=currentLiveEvent();
  // Standalone / File Mode: no in-game event, so auto_start/follow_leader have
  // nothing to key off. Soften them with an explanatory tooltip; manual Start
  // (S) and driver targeting still work.
  const standalone=liveEvents.length===0;
  const badge=$('standalone_badge');
  if(badge){
    badge.style.display=standalone?'inline-block':'none';
    badge.textContent=standalone?'Standalone / File Mode — manual Start (S) & driver target active':'';
  }
  ['auto_start','follow_leader'].forEach(id=>{
    const el=$(id);if(!el)return;
    el.disabled=standalone;
    if(standalone)el.title='Requires active in-game event';
    else el.removeAttribute?el.removeAttribute('title'):el.title='';
  });
  $('live_current').textContent=cur?('Current Event: '+cur.name+' ('+((cur.waypoints||[]).length)+' waypoints)'):'No in-game event detected';
  $('live_load_btn').disabled=!cur;
  const sel=$('live_events'),keep=sel.value;
  sel.innerHTML='';
  liveEvents.forEach((ev,i)=>{
    const o=document.createElement('option');
    o.value=String(i);
    o.textContent=ev.name+' ('+((ev.waypoints||[]).length)+' wp)'+(ev.is_member?'  ← current':'');
    sel.appendChild(o);
  });
  if([...sel.options].some(o=>o.value===keep))sel.value=keep;
}
function liveEventDoc(ev){
  return {RouteName:ev.name||'live event',Waypoints:(ev.waypoints||[]).map(w=>{
    const loc=(w.Location||w.location||w.Translation||w.translation);
    return loc?{Location:loc,Scale3D:{Y:w.gate_m!==undefined?w.gate_m:18}}:
      {Location:{X:w.x!==undefined?w.x:0,Y:w.y!==undefined?w.y:0,Z:w.z!==undefined?w.z:0},
       Scale3D:{Y:w.gate_m!==undefined?w.gate_m:18}};
  })};
}
function setParsed(parsed,label){
  currentTrackName=parsed.name||label||'Track';
  currentParsed=parsed;currentPoints=parsed.points;currentGates=parsed.gates;
  currentRoute=routePlanner.fallbackRouteExport(currentPoints);
  const script=routePlanner.buildShots(parsed.name,currentPoints,currentGates,{tracksideStride:'auto'});
  drawTrackPreview(currentPoints,script.shots);
  note(label+': '+(currentPoints.length)+' waypoints → '+script.shots.length+' shots'+
    (script.source.closed_loop?' (closed loop)':' (point-to-point)'));
  $('out').textContent='PLANNED '+parsed.name+' → '+script.shots.length+' shots\n'+$('out').textContent;
  return script;
}
async function loadCurrentLiveEvent(){
  window.__rcAutoload=true;
  note('AUTOLOAD current live event…');
  await refreshLiveEvents();
  const ev=currentLiveEvent();
  if(!ev){note('No current in-game event to autoload');return null}
  const idx=liveEvents.indexOf(ev);
  if(idx>=0)$('live_events').value=String(idx);
  return applyLiveEvent(ev);
}
async function applyLiveEvent(ev){
  try{
    const script=setParsed(routePlanner.parseRoute(liveEventDoc(ev)),ev.name||'live event');
    return postPlan(ev.name||'live event',script);
  }catch(e){note('live event parse failed: '+e);return null}
}
async function applySelectedLiveEvent(){
  const ev=liveEvents[Number($('live_events').value)];
  if(!ev){note('Pick a server event first');return null}
  return applyLiveEvent(ev);
}
async function postAutoFlags(){
  const body={auto_start:$('auto_start').checked,follow_leader:$('follow_leader').checked};
  try{
    const j=await(await fetch('/api/auto_flags',{method:'POST',
      headers:Object.assign({'content-type':'application/json'},hdr()),body:JSON.stringify(body)})).json();
    $('out').textContent='AUTO_FLAGS '+JSON.stringify(body)+' → '+JSON.stringify(j)+'\n'+$('out').textContent;
    return j;
  }catch(e){note('auto_flags failed: '+e);return null}
}
async function refreshPlans(){
  try{
    const j=await(await fetch('/api/plans',{headers:hdr()})).json();
    const plans=Array.isArray(j.plans)?j.plans:(Array.isArray(j)?j:[]);
    const sel=$('saved_plans'),keep=sel.value;
    sel.innerHTML='';
    plans.forEach(p=>{
      const id=(p&&p.id)||(p&&p.plan_id)||String(p);
      const o=document.createElement('option');o.value=String(id);o.textContent=String(id);sel.appendChild(o);
    });
    if([...sel.options].some(o=>o.value===keep))sel.value=keep;
    return plans;
  }catch(e){note('plans unavailable: '+e);return []}
}
async function loadPlanFromServer(){
  if(!currentPoints||!currentGates){note('Load a route first (live event, file or saved plan)');return null}
  const planId=$('saved_plans').value||'current';
  const script=routePlanner.buildShots(currentParsed.name,currentPoints,currentGates,{tracksideStride:'auto'});
  return postPlan(planId,script);
}
async function postPlan(planId,script){
  try{
    const body={plan_id:planId,plan:script,route:currentRoute||routePlanner.fallbackRouteExport(currentPoints||[])};
    const j=await(await fetch('/api/plan',{method:'POST',
      headers:Object.assign({'content-type':'application/json'},hdr()),body:JSON.stringify(body)})).json();
    $('out').textContent='PLAN '+planId+' → '+JSON.stringify(j)+'\n'+$('out').textContent;
    note('Applied '+planId+' ('+script.shots.length+' shots)');
    return j;
  }catch(e){note('plan apply failed: '+e);return null}
}
/* ---- Universal input path: full-card drop / Discord paste / inbox / pins ---- */
function pointsFromRoute(route,plan){
  if(route&&Array.isArray(route.waypoints)&&route.waypoints.length){
    try{return routePlanner.parseRoute({RouteName:'imported',Waypoints:route.waypoints}).points}catch(e){}
  }
  if(route&&Array.isArray(route.samples)&&route.samples.length){
    return route.samples.map(s=>[Number(s.x)||0.0,Number(s.y)||0.0,Number(s.z)||0.0]);
  }
  if(plan&&Array.isArray(plan.shots)){
    const pts=plan.shots.filter(s=>Array.isArray(s.location)).map(s=>s.location.map(Number));
    if(pts.length)return pts;
  }
  return [];
}
function applyParsedInput(res,label,autoApply){
  if(!res)return null;
  if(res.mode==='prebuilt_plan'){
    const pts=pointsFromRoute(res.route,res.plan);
    currentTrackName=(res.plan&&res.plan.name)||res.plan_id||label||'Track';
    currentParsed=null;currentPoints=pts;currentGates=pts.map(()=>18);
    currentRoute=res.route||routePlanner.fallbackRouteExport(pts);
    currentPlanId=res.plan_id;
    drawTrackPreview(pts,res.plan.shots);
    note(label+': pre-built plan → '+res.plan.shots.length+' shots (camera coordinates preserved)');
    $('out').textContent='PLAN '+res.plan_id+' → pre-built ('+res.plan.shots.length+' shots)\n'+$('out').textContent;
    if(autoApply)return postPlan(res.plan_id,res.plan);
    return res.plan;
  }
  currentTrackName=res.parsed.name||res.plan_id||label||'Track';
  currentParsed=res.parsed;currentPoints=res.parsed.points;currentGates=res.parsed.gates;
  currentRoute=res.route;currentPlanId=res.plan_id;
  drawTrackPreview(currentPoints,res.plan.shots);
  note(label+' ('+res.parsed.name+'): '+currentPoints.length+' waypoints → '+res.plan.shots.length+' shots'+
    (res.plan.source.closed_loop?' (closed loop)':' (point-to-point)'));
  $('out').textContent='PLANNED '+res.parsed.name+' → '+res.plan.shots.length+' shots\n'+$('out').textContent;
  if(autoApply)return postPlan(res.plan_id,res.plan);
  return res.plan;
}
function handleRawInput(text,label,autoApply){
  try{return applyParsedInput(routePlanner.parseAnyInput(text,label),label,autoApply)}
  catch(e){note('bad input ('+label+'): '+e);
    $('out').textContent='INPUT ERR '+e+'\n'+$('out').textContent;return null}
}
function readTrackFile(file){
  const r=new FileReader();
  r.onload=()=>handleRawInput(String(r.result),file.name||'file',!!$('auto_apply').checked);
  r.readAsText(file);
}
function pickTrackFile(){$('track_file').click()}
function parsePasted(){
  const text=$('paste_json').value;
  if(!String(text).trim()){note('Paste a JSON block first');return null}
  return handleRawInput(text,'pasted_track',!!$('auto_apply').checked);
}
async function refreshInbox(){
  try{
    const j=await(await fetch('/api/inbox',{headers:hdr()})).json();
    const names=[];
    if(j&&j.has_drop_file)names.push('drop_event.json');
    const files=(j&&Array.isArray(j.files))?j.files:[];
    files.forEach(f=>{
      const n=(f&&typeof f==='object')?(f.name||f.file||String(f)):String(f);
      if(n&&names.indexOf(n)<0)names.push(n);
    });
    const sel=$('inbox_files'),keep=sel.value;
    sel.innerHTML='';
    names.forEach(n=>{const o=document.createElement('option');o.value=n;o.textContent=n;sel.appendChild(o)});
    if([...sel.options].some(o=>o.value===keep))sel.value=keep;
    $('inbox_load').disabled=names.length===0;
    note('Inbox: '+names.length+' dropped file(s) available');
    return names;
  }catch(e){note('inbox unavailable: '+e);return []}
}
async function loadInboxFile(){
  const name=$('inbox_files').value;
  if(!name){note('No dropped file selected — refresh the inbox');return null}
  try{
    const r=await fetch('/api/inbox_file?name='+encodeURIComponent(name),{headers:hdr()});
    let raw=await r.text();
    try{
      const j=JSON.parse(raw);
      if(j&&typeof j.content==='string')raw=j.content;
      else if(j&&typeof j.text==='string')raw=j.text;
      else if(j&&j.json)raw=JSON.stringify(j.json);
    }catch(e){}
    return handleRawInput(raw,name,!!$('auto_apply').checked);
  }catch(e){note('inbox load failed: '+e);return null}
}
/* ---- Free-roam Pin Position: zero-file waypoint capture ---- */
function pinDoc(){return JSON.stringify({route_name:'Free-Roam Pins',waypoints:pins.slice()})}
function refreshPinPreview(){
  $('pin_count').textContent=pins.length+' pins';
  $('pin_build').disabled=pins.length<3;
  if(pins.length>=3)handleRawInput(pinDoc(),'free_roam',false);
  else if(pins.length)note(pins.length+' pins — need at least 3 to build a route');
}
function posFrom(j){
  if(!j)return null;
  let p=j;
  for(const k of ['pos','position','location','Location','Translation','translation','player']){
    if(p&&isObj(p[k])){p=p[k];break}
  }
  if(Array.isArray(p))return {x:Number(p[0])||0.0,y:Number(p[1])||0.0,z:Number(p[2])||0.0,gate_m:18};
  const px=(p.X!==undefined?p.X:(p.x!==undefined?p.x:undefined));
  const py=(p.Y!==undefined?p.Y:(p.y!==undefined?p.y:undefined));
  const pz=(p.Z!==undefined?p.Z:(p.z!==undefined?p.z:undefined));
  if(px===undefined||py===undefined||pz===undefined)return null;
  return {x:Number(px),y:Number(py),z:Number(pz),gate_m:18};
}
async function pinPosition(){
  try{
    const j=await(await fetch('/api/my_pos',{headers:hdr()})).json();
    const p=posFrom(j);
    if(!p){note('/api/my_pos returned no usable position');return null}
    pins.push(p);refreshPinPreview();
    return p;
  }catch(e){note('pin failed: '+e);return null}
}
function undoPin(){if(pins.length){pins.pop();refreshPinPreview()}return pins.length}
function clearPins(){pins=[];refreshPinPreview();note('Pins cleared');return 0}
async function buildPins(){
  if(pins.length<3){note('Need at least 3 pins to build a route');return null}
  const res=routePlanner.parseAnyInput(pinDoc(),'free_roam');
  return applyParsedInput(res,'Free-Roam Pins ('+pins.length+' pins)',true);
}
function drawTrackPreview(points,shots){
  collapseSetup();
  const pm=$('pv_meta');
  if(pm)pm.textContent=(points&&points.length)?(currentTrackName+' · '+points.length+' waypoints · '+((shots&&shots.length)||0)+' shots'):'No route loaded';
  if(!points||!points.length)return;
  ['pv_canvas','track_canvas'].forEach(cid=>{
  const c=$(cid),ctx=c&&c.getContext?c.getContext('2d'):null;
  if(!ctx)return;
  const W=c.width||640,H=c.height||320,pad=28;
  ctx.clearRect(0,0,W,H);ctx.fillStyle='#0c0c0c';ctx.fillRect(0,0,W,H);
  let minX=Infinity,maxX=-Infinity,minY=Infinity,maxY=-Infinity;
  for(const p of points){minX=Math.min(minX,p[0]);maxX=Math.max(maxX,p[0]);minY=Math.min(minY,p[1]);maxY=Math.max(maxY,p[1])}
  (shots||[]).forEach(s=>{if(s.location){minX=Math.min(minX,s.location[0]);maxX=Math.max(maxX,s.location[0]);
    minY=Math.min(minY,s.location[1]);maxY=Math.max(maxY,s.location[1])}});
  if(maxX-minX<1)maxX=minX+1;
  if(maxY-minY<1)maxY=minY+1;
  const sx=(W-2*pad)/(maxX-minX),sy=(H-2*pad)/(maxY-minY),s=Math.min(sx,sy);
  const X=x=>pad+(x-minX)*s,Y=y=>H-pad-(y-minY)*s;
  ctx.strokeStyle='#63b3ed';ctx.lineWidth=2;ctx.beginPath();
  points.forEach((p,i)=>{i?ctx.lineTo(X(p[0]),Y(p[1])):ctx.moveTo(X(p[0]),Y(p[1]))});
  if(isClosedLoop(points))ctx.closePath();
  ctx.stroke();
  const mark=(p,col,label)=>{
    ctx.fillStyle=col;ctx.beginPath();ctx.arc(X(p[0]),Y(p[1]),5,0,Math.PI*2);ctx.fill();
    ctx.fillStyle='#eee';ctx.font='11px system-ui';ctx.fillText(label,X(p[0])+7,Y(p[1])-7);
  };
  mark(points[0],'#48bb78','START');
  mark(points[points.length-1],'#f56565','FINISH');
  let num=0;
  (shots||[]).forEach(sh=>{
    if(!sh.location||!sh.id||sh.id.indexOf('corner_')!==0)return;
    num++;
    const px=X(sh.location[0]),py=Y(sh.location[1]);
    ctx.strokeStyle='#ed8936';ctx.lineWidth=1;ctx.beginPath();ctx.arc(px,py,7,0,Math.PI*2);ctx.stroke();
    ctx.fillStyle='#ed8936';ctx.font='bold 11px system-ui';ctx.fillText(String(dataTrackIndex(sh)),px+9,py+4);
    if(sh.look_at){
      const dx=sh.look_at[0]-sh.location[0],dy=sh.look_at[1]-sh.location[1];
      const m=Math.hypot(dx,dy)||1,ux=dx/m,uy=dy/m;
      ctx.strokeStyle='rgba(237,137,54,.6)';ctx.beginPath();
      ctx.moveTo(px-ux*10,py+uy*10);ctx.lineTo(px+ux*14,py-uy*14);ctx.stroke();
    }
  });
  });
}

function dataTrackIndex(sh){
  const m=/corner_(\d+)_pan/.exec(sh.id);
  return m?Number(m[1]):0;
}

/* ---- OBS WebSocket v5 client (unchanged protocol, + convenience) ---- */
/* Password is only persisted in localStorage when the opt-in box is ticked. */
let obs=null,obsId=0,obsCheckPending=false;const obsPend={};
const K=[0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2];
function sha256(msg){
  const u=unescape(encodeURIComponent(msg)),L=u.length,bl=L*8;
  const pad=Math.ceil((L+9)/64)*64,b=new Uint8Array(pad),dv=new DataView(b.buffer);
  for(let i=0;i<L;i++)b[i]=u.charCodeAt(i)&255;
  b[L]=128;dv.setUint32(pad-8,Math.floor(bl/4294967296));dv.setUint32(pad-4,bl>>>0);
  const h=[0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19];
  const w=new Uint32Array(64);
  for(let o=0;o<pad;o+=64){
    for(let i=0;i<16;i++)w[i]=dv.getUint32(o+i*4);
    for(let i=16;i<64;i++){
      const x=w[i-15],y=w[i-2];
      const s0=((x>>>7|x<<25)^(x>>>18|x<<14)^(x>>>3))>>>0;
      const s1=((y>>>17|y<<15)^(y>>>19|y<<13)^(y>>>10))>>>0;
      w[i]=(w[i-16]+s0+w[i-7]+s1)>>>0;
    }
    let a=h[0],b2=h[1],c=h[2],d=h[3],e=h[4],f=h[5],g=h[6],hh=h[7];
    for(let i=0;i<64;i++){
      const S1=((e>>>6|e<<26)^(e>>>11|e<<21)^(e>>>25|e<<7))>>>0;
      const ch=(e&f)^(~e&g);
      const t1=(hh+S1+ch+K[i]+w[i])>>>0;
      const S0=((a>>>2|a<<30)^(a>>>13|a<<19)^(a>>>22|a<<10))>>>0;
      const mj=(a&b2)^(a&c)^(b2&c);
      const t2=(S0+mj)>>>0;
      hh=g;g=f;f=e;e=(d+t1)>>>0;d=c;c=b2;b2=a;a=(t1+t2)>>>0;
    }
    h[0]=(h[0]+a)>>>0;h[1]=(h[1]+b2)>>>0;h[2]=(h[2]+c)>>>0;h[3]=(h[3]+d)>>>0;
    h[4]=(h[4]+e)>>>0;h[5]=(h[5]+f)>>>0;h[6]=(h[6]+g)>>>0;h[7]=(h[7]+hh)>>>0;
  }
  return h.map(x=>('00000000'+x.toString(16)).slice(-8)).join('');
}
function hexB64(h){let s='';for(let i=0;i<h.length;i+=2)s+=String.fromCharCode(parseInt(h.substr(i,2),16));return btoa(s)}
function sha256b64(s){return hexB64(sha256(s))}
function obsSet(t){$('obsst').textContent=t;setObsPill(t);toast(t)}
function obsConnect(){
  syncObsAliases();
  let u; try{u=new URL(($('obsurl').value||$('obs_url').value||'ws://127.0.0.1:4455').trim())}catch(e){obsSet('bad url');return}
  if(u.protocol!=='ws:'||!['127.0.0.1','localhost'].includes(u.hostname)){obsSet('OBS WS must be localhost');return}
  const url=u.href;
  if(obs){try{obs.close()}catch(e){}}
  Object.keys(obsPend).forEach(k=>delete obsPend[k]);
  try{obs=new WebSocket(url)}catch(e){obsSet('bad url');return}
  const my=obs;
  obsSet('connecting…');
  obs.onmessage=ev=>{
    if(obs!==my)return;
    let m;try{m=JSON.parse(ev.data)}catch(e){return}
    if(m.op===0&&m.d){
      const d={rpcVersion:(m.d.rpcVersion!=null)?m.d.rpcVersion:1};
      if(m.d.authentication){
        const a=m.d.authentication;
        d.authentication=sha256b64(sha256b64(($('obspw').value||'')+a.salt)+a.challenge);
      }
      obs.send(JSON.stringify({op:1,d}));
    }else if(m.op===2&&m.d){
      obsSet('connected');obsScenes();
      if(obsCheckPending){obsCheckPending=false;setTimeout(()=>obsShot(),200)}
    }else if(m.op===7&&m.d){
      const cb=obsPend[m.d.requestId];
      if(cb){delete obsPend[m.d.requestId];cb(m.d)}
    }
  };
  obs.onerror=()=>{if(obs===my)obsSet('error (auth refused or wrong URL)')};
  obs.onclose=()=>{if(obs===my)obsSet('disconnected')};
}
function obsDisc(){if(obs){try{obs.close()}catch(e){}}obsSet('disconnected')}
function obsReq(rt,rd,cb){
  if(!obs||obs.readyState!==1){obsSet('not connected');return}
  const id='r'+(++obsId);obsPend[id]=cb||function(){};
  obs.send(JSON.stringify({op:6,d:{requestType:rt,requestData:rd||{},requestId:id}}));
}
function obsScenes(){syncObsAliases();obsReq('GetSceneList',{},d=>{
  if(!(d.requestStatus&&d.requestStatus.result)){obsSet('scene list failed');return}
  const s=$('obsscene');s.innerHTML='';
  (d.responseData.scenes||[]).forEach(sc=>{let o=document.createElement('option');o.value=sc.sceneName;o.textContent=sc.sceneName;s.appendChild(o)});
  if(d.responseData.currentProgramSceneName)s.value=d.responseData.currentProgramSceneName;
  const scenes=(d.responseData.scenes||[]).map(sc=>sc.sceneName);
  const ss=$('obs_sc');
  if(ss){ss.innerHTML='';scenes.forEach(sc=>{let o=document.createElement('option');o.value=sc;o.textContent=sc;ss.appendChild(o)});ss.value=s.value}
  renderObsScenePads(scenes,s.value);
  obsSources();
})}
function obsSources(){
  syncObsAliases();
  const sc=$('obsscene').value;if(!sc)return;
  obsReq('GetSceneItemList',{sceneName:sc},d=>{
    const s=$('obssrc');s.innerHTML='';
    if(d.responseData)(d.responseData.sceneItems||[]).forEach(it=>{let o=document.createElement('option');o.value=it.sourceName;o.textContent=it.sourceName;s.appendChild(o)});
  });
}
function obsSetScene(){
  syncObsAliases();
  const sc=$('obsscene').value;
  obsReq('SetCurrentProgramScene',{sceneName:sc},d=>obsSet((d.requestStatus&&d.requestStatus.result)?'scene set: '+sc:'scene switch failed'));
}
function obsRec(start){
  if(rehearsal&&start){obsSet('REHEARSAL: record start suppressed');return}
  obsReq(start?'StartRecord':'StopRecord',{},d=>obsSet((d.requestStatus&&d.requestStatus.result)?(start?'recording':'record stopped'):'record command failed'));
}
function obsShot(){
  const src=$('obssrc').value;
  if(!src){obsSet('pick a source first');return}
  obsReq('GetSourceScreenshot',{sourceName:src,imageFormat:'png'},d=>{
    if(d.responseData&&d.responseData.imageData){const im=$('obsprev');im.src=d.responseData.imageData;im.style.display='block'}
    else obsSet('screenshot failed');
  });
}
function obsCheck(){
  obsSet('checking…');
  if(!obs||obs.readyState!==1){
    obsCheckPending=true;obsConnect();return;
  }
  obsScenes();obsSet('connected — refreshing scenes + preview');
  setTimeout(()=>obsShot(),200);
}
function obsRememberChange(){
  const np=$('obs_pw'),lp=$('obspw'),nr=$('obs_rem'),lr=$('obs_remember');
  const raw=String((np&&np.value)||(lp&&lp.value)||'');
  const on=!!((nr&&nr.checked)||(lr&&lr.checked));
  if(on){
    localStorage.setItem('rc_obs_pw',raw);
    localStorage.setItem('rc_obs_pw_saved','1');
  }else{
    localStorage.removeItem('rc_obs_pw');localStorage.removeItem('rc_obs_pw_saved');
  }
}

/* ---- boot: hash token + autoload, live events, plans, OBS reconnect ---- */
(function boot(){
  $('track_file').addEventListener('change',e=>{const f=e.target.files&&e.target.files[0];if(f)readTrackFile(f)});
  // One delegated handler survives every roster rebuild: a click on any driver
  // button cuts the target immediately, even between 700 ms polls.
  $('contestants').addEventListener('click',e=>{
    const t=e&&e.target,btn=t&&t.closest&&t.closest('button[data-rc-target]');
    if(btn)setTargetByName(btn.getAttribute('data-rc-target'));
  });
  // Broadcast Desk v2: delegated pads/cues/scenes survive every DOM rebuild.
  const padClick=e=>{
    const t=e&&e.target,b=t&&t.closest&&t.closest('[data-rc-shot]');
    if(!b)return;
    const id=b.getAttribute('data-rc-shot');
    if(takeMode)stageShot(id);else trigger(id);
  };
  $('shot_pads').addEventListener('click',padClick);
  $('shot_pads_extra').addEventListener('click',padClick);
  $('q').addEventListener('click',e=>{
    const t=e&&e.target,b=t&&t.closest&&t.closest('[data-cue-remove]');
    if(!b)return;
    const i=Number(b.getAttribute('data-cue-remove'));
    if(!isFinite(i))return;
    cueList.splice(i,1);cmd('queue',JSON.stringify(cueList));renderCues();
  });
  $('obs_scene_pads').addEventListener('click',e=>{
    const t=e&&e.target,b=t&&t.closest&&t.closest('[data-rc-scene]');
    if(!b)return;
    const sc=b.getAttribute('data-rc-scene');
    if(sc){$('obs_sc').value=sc;syncObsAliases();obsSetScene()}
  });
  document.addEventListener('focusin',updateKeysPill);
  document.addEventListener('focusout',()=>{setTimeout(updateKeysPill,0)});
  updateKeysPill();
  $('drop_zone').addEventListener('click',pickTrackFile);
  const card=$('track_loader_card');
  card.addEventListener('dragover',e=>{
    e.preventDefault();
    if(e.dataTransfer)e.dataTransfer.dropEffect='copy';
    card.className='card drop-over';
  });
  card.addEventListener('dragleave',()=>{card.className='card'});
  card.addEventListener('drop',e=>{
    e.preventDefault();card.className='card';
    const dt=e.dataTransfer,files=dt&&dt.files;
    let f=null;
    if(files&&files.length){
      for(let i=0;i<files.length;i++){
        const nm=String(files[i].name||'');
        if(/\.(json|txt)$/i.test(nm)){f=files[i];break}
      }
      if(!f)f=files[0];
    }
    if(f)readTrackFile(f);
    else note('Drop a .json or .txt event / route / plan file onto this card');
  });
  // Paste straight from Discord while focus is anywhere inside the card.
  card.addEventListener('paste',e=>{
    const txt=e.clipboardData&&e.clipboardData.getData&&e.clipboardData.getData('text');
    if(!txt)return;
    const t=String(txt).trim();
    if(/^(\{|\[|```)/.test(t)){
      e.preventDefault();
      $('paste_json').value=t;
      handleRawInput(t,'pasted_track',!!$('auto_apply').checked);
    }
  });
  $('obs_remember').addEventListener('change',obsRememberChange);
  $('obs_rem').addEventListener('change',()=>{syncObsAliases();obsRememberChange()});
  if(localStorage.getItem('rc_obs_pw_saved')==='1'){
    const savedPw=localStorage.getItem('rc_obs_pw')||'';
    $('obspw').value=savedPw;
    $('obs_pw').value=savedPw;
    $('obs_remember').checked=true;
    $('obs_rem').checked=true;
    obsConnect();
  }
  const hash=location.hash||'';
  if(hash.charAt(0)==='#'){
    const params=new URLSearchParams(hash.slice(1));
    const hashTok=params.get('token');
    if(hashTok){
      tok=hashTok;
      try{localStorage.setItem('rc_tok',tok)}catch(e){}
      try{sessionStorage.setItem('racecam_tok',tok)}catch(e){}
      $('tok').value=tok;
      setAuthPill();
      history.replaceState(null,'','/');
      if(params.get('autoload')==='current')loadCurrentLiveEvent();
    }
  }
  // Setup stays open only while there is no route; other drawers start shut.
  const setup=$('drawer_setup');if(setup)setup.open=!currentPoints;
  const conn=$('drawer_conn');if(conn)conn.open=false;
  const logDrawer=$('drawer_log');if(logDrawer)logDrawer.open=false;
  setAuthPill();
  poll();  // start live polling only after the hash token has been applied
  refreshLiveEvents();
  refreshPlans();
  refreshInbox();
})();
window.racecamPanel={cmd:cmd,trigger:trigger,enqueue:enqueue,undo:undo,toggleRehearsal:toggleRehearsal,
  refreshLiveEvents:refreshLiveEvents,loadCurrentLiveEvent:loadCurrentLiveEvent,
  applySelectedLiveEvent:applySelectedLiveEvent,postAutoFlags:postAutoFlags,
  parseAnyInput:parseAnyInput,applyParsedInput:applyParsedInput,handleRawInput:handleRawInput,
  parsePasted:parsePasted,refreshInbox:refreshInbox,loadInboxFile:loadInboxFile,
  pinPosition:pinPosition,undoPin:undoPin,clearPins:clearPins,buildPins:buildPins,
  refreshPlans:refreshPlans,loadPlanFromServer:loadPlanFromServer,
  obsConnect:obsConnect,obsCheck:obsCheck,obsScenes:obsScenes,obsShot:obsShot,
  sha256:sha256,sha256b64:sha256b64,routePlanner:window.routePlanner,
  renderContestants:renderContestants,setTargetByName:setTargetByName,lockTyped:lockTyped,
  setSmoothing:setSmoothing,highlightSmoothing:highlightSmoothing,poll:poll,
  getSmoothingMode:()=>smoothingMode,
  setDirector:setDirector,highlightDirector:highlightDirector,renderDirBadge:renderDirBadge,
  getDirectorMode:()=>directorMode,
  getDirectorState:()=>({mode:directorMode,reason:directorReason,override_s:directorOverrideS}),
  getRosterNames:()=>rosterNames.slice(),getRosterSig:()=>lastRosterSig,
  renderShotDeck:renderShotDeck,renderCues:renderCues,stageShot:stageShot,takeShot:takeShot,
  toggleMode:toggleMode,toggleFollow:toggleFollow,toggleRec:toggleRec,isTakeMode:isTakeMode,
  getStagedShot:()=>stagedShot,getDeckSig:()=>lastDeckSig,updateKeysPill:updateKeysPill,
  collapseSetup:collapseSetup,openSetup:openSetup,toggleConnDrawer:toggleConnDrawer,
  renderObsScenePads:renderObsScenePads,setAuthPill:setAuthPill,setObsPill:setObsPill,
  syncObsAliases:syncObsAliases,toast:toast};
</script></body></html>]=]

return M
