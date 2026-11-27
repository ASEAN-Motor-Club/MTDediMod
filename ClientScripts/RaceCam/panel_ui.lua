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
body{font:14px system-ui;background:#111;color:#eee;margin:0;padding:16px}
h1{font-size:18px;margin:0 0 12px}h2{font-size:15px;margin:0 0 8px}
.card{background:#1b1b1b;border:1px solid #333;border-radius:6px;padding:12px;margin-bottom:12px}
button{background:#2b6cb0;border:0;color:#fff;padding:8px 12px;border-radius:4px;cursor:pointer;margin:2px}
button:hover{background:#3182ce}button:disabled{background:#444;color:#888;cursor:not-allowed}
input,select{background:#222;color:#eee;border:1px solid #444;padding:6px;border-radius:4px}
input[type=checkbox]{width:auto}label{margin-right:10px}
pre{background:#0c0c0c;border:1px solid #333;padding:8px;max-height:220px;overflow:auto;white-space:pre-wrap}
.badge{display:inline-block;padding:6px 14px;border-radius:4px;font-weight:bold;margin-right:8px}
.tally-on-prog{background:#c53030}.tally-on-prev{background:#2f855a}.tally-off{background:#444;color:#aaa}
#banner{display:none;padding:10px;border-radius:4px;margin-bottom:12px;font-weight:bold}
#banner.degraded{display:block;background:#742a2a;color:#fff}
#banner.rehearsal{display:block;background:#975a16;color:#fff}
.kbd{color:#888;font-size:12px;margin-top:6px}
.muted{color:#999;font-size:12px}
#drop_zone{border:1px dashed #555;border-radius:6px;padding:10px;text-align:center;color:#999;margin:6px 0;cursor:pointer}
#drop_zone.over{background:#234;color:#fff}
#track_canvas{display:block;width:100%;max-width:640px;height:auto;background:#0c0c0c;border:1px solid #444;border-radius:4px;margin-top:8px}
hr{border:0;border-top:1px solid #333;margin:10px 0}
</style></head><body>
<h1>AMC RaceCam — local operator</h1>
<div id="banner"></div>
<div class="card">Token: <input id="tok" type="password" placeholder="optional"> <button onclick="save()">Set</button>
&nbsp;REHEARSAL: <button id="rehb" onclick="toggleRehearsal()">OFF</button> <span class="kbd">(R)</span></div>
<div class="card">
<span class="badge tally-off" id="prog">PROGRAM —</span><span class="badge tally-off" id="prv">PREVIEW —</span>
Active: <b id="shot">—</b> &nbsp; FOV: <b id="fov">—</b> &nbsp; Plan: <b id="plan">—</b>
&nbsp; Countdown: <b id="cd">—</b> &nbsp; HB age: <b id="hb">—</b> &nbsp; Camera: <b id="run">—</b>
</div>
<div class="card">Cue queue: <span id="queue">—</span>
<input id="qat" size="7" placeholder="t+ sec">
<button onclick="enqueue()">Queue cue (Q)</button>
<button onclick="cmd('next')">Next cue (N)</button> <button onclick="cmd('queue_clear')">Clear queue</button></div>
<div class="card">
<button onclick="cmd('arm')">Arm (A)</button><button onclick="cmd('start')">Start (S)</button>
<button onclick="cmd('stop')">Stop / restore view (X)</button><button onclick="undo()">Last-shot undo (Z)</button><br>
<select id="sid"></select><button onclick="trigger(sid.value)">Trigger shot (1-9)</button><br>
Contestant: <select id="pname"></select><button onclick="cmd('select',pname.value)">Follow</button>
or type: <input id="pname_text" size="12" placeholder="driver name"><button onclick="followTyped()">Follow typed</button>
</div>
<div class="card"><h2>Track Loader &amp; Live Event</h2>
<div id="live_current" class="muted">No in-game event detected</div>
<button id="live_refresh" onclick="refreshLiveEvents()">Refresh events</button>
<button id="live_load_btn" onclick="loadCurrentLiveEvent()" disabled>Load &amp; Preview</button><br>
Server events: <select id="live_events"></select>
<button onclick="applySelectedLiveEvent()">Load &amp; Apply selected</button><br>
<label><input id="auto_start" type="checkbox" onchange="postAutoFlags()"> Auto-Start on Green Light</label>
<label><input id="follow_leader" type="checkbox" onchange="postAutoFlags()"> Follow Race Leader</label>
<div class="kbd">Auto flags are opt-in and sent to /api/auto_flags only when you tick them.</div>
<hr>
<div>Track JSON: <input id="track_file" type="file" accept=".json,application/json">
<button onclick="pickTrackFile()">Choose file</button></div>
<div id="drop_zone">or drop a .json file here</div>
Saved plans: <select id="saved_plans"></select>
<button id="plans_refresh" onclick="refreshPlans()">Refresh</button>
<button id="plan_load" onclick="loadPlanFromServer()">Load &amp; Apply</button><br>
<span id="track_info" class="muted">No route loaded. Planner runs entirely in this page — no Python needed.</span>
<canvas id="track_canvas" width="640" height="320"></canvas>
</div>
<div class="card">
OBS WebSocket: <input id="obsurl" size="28" value="ws://127.0.0.1:4455">
Password: <input id="obspw" type="password" size="12">
<button onclick="obsConnect()">Connect</button> <button onclick="obsDisc()">Disconnect</button>
<span id="obsst">disconnected</span><br>
<button id="obs_check" onclick="obsCheck()">Check OBS</button>
<label><input id="obs_remember" type="checkbox"> Remember OBS password on this PC</label><br>
<button onclick="obsRec(true)">Start record</button><button onclick="obsRec(false)">Stop record</button>
Scene: <select id="obsscene" onchange="obsSources()"></select>
<button onclick="obsScenes()">Refresh scenes</button>
<button onclick="obsSetScene()">Go to scene</button><br>
Source: <select id="obssrc"></select> <button onclick="obsShot()">Preview</button>
<img id="obsprev" style="max-width:320px;display:none;border:1px solid #444;margin-top:6px">
</div>
<div class="card"><pre id="out"></pre>
<div class="kbd">A arm · S start · X stop · 1-9 trigger shot · N next cue · Z last-shot undo · R rehearsal toggle</div></div>
<script>
const $=id=>document.getElementById(id);
let tok=localStorage.getItem('rc_tok')||sessionStorage.getItem('racecam_tok')||'';$('tok').value=tok;
function save(){tok=$('tok').value;try{localStorage.setItem('rc_tok',tok)}catch(e){}try{sessionStorage.setItem('racecam_tok',tok)}catch(e){}}
function hdr(){return tok?{'x-racecam-token':tok}:{}}
let rehearsal=false,shotHist=[],windowDegraded=false,windowTargetLost=false;

async function toggleRehearsal(){
  const next=!rehearsal;
  const j=await cmd('rehearsal',next?'on':'off');
  if(j&&j.status&&j.status.indexOf('on')>=0)rehearsal=true;
  else if(j&&j.status&&j.status.indexOf('off')>=0)rehearsal=false;
  $('rehb').textContent=rehearsal?'ON':'OFF';banner();
}
function banner(){
  const b=$('banner');b.className='';b.textContent='';
  if(windowDegraded){b.className='degraded';b.textContent='DEGRADED — operator heartbeat lost, shots stopped. Press Arm (A), then Start (S) to resume.'}
  else if(windowTargetLost){b.className='degraded';b.textContent='TARGET LOST — followed player not found; holding last camera pose.'}
  else if(rehearsal){b.className='rehearsal';b.textContent='REHEARSAL — camera and OBS record commands are suppressed'}
}
async function cmd(c,a){
  try{
    let r=await fetch('/api/command',{method:'POST',headers:Object.assign({'content-type':'application/json'},hdr()),body:JSON.stringify({cmd:c,args:a||''})});
    let j=await r.json();
    $('out').textContent=JSON.stringify(j)+'\n'+$('out').textContent;
    return j;
  }catch(e){$('out').textContent='ERR '+e+'\n'+$('out').textContent}
}
let cueList=[];
function trigger(id){if(!id)return;shotHist.push(id);if(shotHist.length>50)shotHist.shift();cmd('trigger',id)}
function enqueue(){
  const id=$('sid').value.trim(); if(!id)return;
  const at=$('qat').value.trim();
  const cue=at?{id:id,at_t:parseFloat(at)}:{id:id};
  cueList.push(cue);
  cmd('queue',JSON.stringify(cueList));
  $('qat').value='';
}
function undo(){shotHist.pop();const p=shotHist[shotHist.length-1];if(p)cmd('trigger',p);else cmd('stop')}
function followTyped(){const n=$('pname_text').value.trim();if(n)cmd('select',n)}
document.addEventListener('keydown',e=>{
  const t=(e.target&&e.target.tagName)||'';
  if(/INPUT|SELECT|TEXTAREA/.test(t))return;
  const k=e.key.toLowerCase();
  if(k==='a')cmd('arm');
  else if(k==='s')cmd('start');
  else if(k==='x')cmd('stop');
  else if(k==='n')cmd('next');
  else if(k==='q')enqueue();
  else if(k==='z')undo();
  else if(k==='r')toggleRehearsal();
  else if(/^[1-9]$/.test(k)){const o=$('sid').options[+k-1];if(o)trigger(o.value)}
});

async function poll(){
  try{
    let s=await(await fetch('/api/state',{headers:hdr()})).json();
    windowDegraded=!!s.degraded;
    windowTargetLost=!!s.target_lost;
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
    if(s.targets&&s.targets.length){
      const keep=$('pname').value;
      $('pname').innerHTML='';
      s.targets.forEach(n=>{let o=document.createElement('option');o.value=n;o.textContent=n;$('pname').appendChild(o)});
      if([...$('pname').options].some(o=>o.value===keep))$('pname').value=keep;
    }
  }catch(e){}
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
const prevIdx=(i,n)=>((i-1)%n+n)%n;
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
function vecOf(d,names){
  if(d===null||typeof d!=='object'||Array.isArray(d))throw new Error('waypoint is not an object');
  for(const k of names){
    if(k in d&&d[k]!==null&&typeof d[k]==='object'&&!Array.isArray(d[k])){
      const c=d[k];
      const pick=(...ks)=>{for(const kk of ks)if(kk in c)return Number(c[kk]);return 0.0};
      return [pick('X','x'),pick('Y','y'),pick('Z','z')];
    }
  }
  if('x' in d||'y' in d||'z' in d){
    return [d.x!==undefined?Number(d.x):0.0,d.y!==undefined?Number(d.y):0.0,d.z!==undefined?Number(d.z):0.0];
  }
  throw new Error('no location key in waypoint');
}
function parseRoute(doc){
  if(doc===null||typeof doc!=='object'||Array.isArray(doc))throw new Error('route JSON must be an object');
  let d=doc;
  if(d.config!==null&&typeof d.config==='object'&&!Array.isArray(d.config))d=d.config;
  const route=(d.Route!==null&&typeof d.Route==='object'&&!Array.isArray(d.Route))?d.Route:d;
  const name=String(route.RouteName||route.routeName||d.name||'unnamed route');
  let raw=(route.Waypoints!==undefined&&route.Waypoints!==null)?route.Waypoints:route.waypoints;
  if(!Array.isArray(raw)||!raw.length)throw new Error('no waypoints found');
  const points=[],gates=[];
  for(const wp of raw){
    points.push(vecOf(wp,['Location','location','Translation','translation']));
    let sc=wp.Scale3D||wp.scale3D||{};
    if(sc===null||typeof sc!=='object'||Array.isArray(sc))sc={};
    let gy;
    if(wp.gate_m!==undefined)gy=wp.gate_m;
    else if('Y' in sc)gy=sc.Y;
    else if('y' in sc)gy=sc.y;
    else gy=18;
    gates.push(Number(gy));
  }
  return {name:name,points:points,gates:gates};
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
function cornerShot(points,gates,i,opts){
  opts=opts||{};
  let d=directionAt(points,i);
  let half=(gates[i]*100.0)/2.0;
  const sample=opts.sample||null;
  if(sample&&sample.kind!=='gap'&&sample.lane_width){
    const h=Number(sample.heading||0.0);
    d=[Math.cos(h),Math.sin(h),0.0];
    half=Number(sample.lane_width)/2.0;
  }
  const nn=leftNormal(d);
  const loc=addv(addv(points[i],scalev(nn,half+500.0)),[0,0,250.0]);
  const at=addv(points[i],scalev(d,800.0));
  return {id:'corner_'+(i<10?'0'+i:i)+'_pan',kind:'trackside_pan',role:'trackside',
    trigger:{type:'manual'},location:loc.map(round3),look_at:at.map(round3),
    fov:70.0,auto_zoom:true,fov_min:28.0,fov_max:65.0};
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
  const startLoc=addv(addv(addv(points[0],scalev(d0,-startBackCm)),scalev(nn0,halfGate+sideMarginCm)),[0,0,300.0]);
  const startAt=addv(points[0],scalev(d0,600.0));
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
  const dn=directionAt(points,n-1),nnLast=leftNormal(dn),halfLast=(gates[n-1]*100.0)/2.0;
  const finishLoc=addv(addv(addv(points[n-1],scalev(nnLast,halfLast+500.0)),scalev(dn,-400.0)),[0,0,tracksideHeightCm]);
  const finishTarget=closed?points[0]:addv(points[n-1],scalev(dn,-800.0));
  shots.push(lookAtShot('finish_line',finishLoc,finishTarget,fovSide));
  let cx=0,cy=0,cz=0;
  for(const p of points){cx+=p[0];cy+=p[1];cz+=p[2]}
  cx/=n;cy/=n;cz/=n;
  shots.push({id:'overview',kind:'look_at',trigger:{type:'manual'},
    location:[round3(cx),round3(cy),round3(cz+overheadCm)],
    look_at:[round3(cx),round3(cy),round3(cz)],fov:fovAir});
  for(const i of rankCorners(points,maxTrackside)){
    shots.push(cornerShot(points,gates,i,{routeExport:routeExport,sample:splineSample(i)}));
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
window.routePlanner={parseRoute:parseRoute,isClosedLoop:isClosedLoop,directionAt:directionAt,
  leftNormal:leftNormal,turnAngle:turnAngle,rankCorners:rankCorners,buildShots:buildShots,
  fallbackRouteExport:fallbackRouteExport,normXY:normXY,distXY:distXY,round3:round3,pyRound:pyRound,
  sub:sub,add:addv,scale:scalev,cornerShot:cornerShot,lookAtShot:lookAtShot,followShot:followShot};

/* ---- Live events / track loader / 2D preview ---- */
let liveEvents=[],currentParsed=null,currentPoints=null,currentGates=null,currentRoute=null;
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
function readTrackFile(file){
  const r=new FileReader();
  r.onload=()=>{
    try{
      const parsed=routePlanner.parseRoute(JSON.parse(String(r.result)));
      setParsed(parsed,file.name||'file');
    }catch(e){note('bad track JSON: '+e)}
  };
  r.readAsText(file);
}
function pickTrackFile(){$('track_file').click()}
function drawTrackPreview(points,shots){
  const c=$('track_canvas'),ctx=c&&c.getContext?c.getContext('2d'):null;
  if(!ctx||!points||!points.length)return;
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
function obsSet(t){$('obsst').textContent=t}
function obsConnect(){
  let u; try{u=new URL(($('obsurl').value||'ws://127.0.0.1:4455').trim())}catch(e){obsSet('bad url');return}
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
function obsScenes(){obsReq('GetSceneList',{},d=>{
  if(!(d.requestStatus&&d.requestStatus.result)){obsSet('scene list failed');return}
  const s=$('obsscene');s.innerHTML='';
  (d.responseData.scenes||[]).forEach(sc=>{let o=document.createElement('option');o.value=sc.sceneName;o.textContent=sc.sceneName;s.appendChild(o)});
  if(d.responseData.currentProgramSceneName)s.value=d.responseData.currentProgramSceneName;
  obsSources();
})}
function obsSources(){
  const sc=$('obsscene').value;if(!sc)return;
  obsReq('GetSceneItemList',{sceneName:sc},d=>{
    const s=$('obssrc');s.innerHTML='';
    if(d.responseData)(d.responseData.sceneItems||[]).forEach(it=>{let o=document.createElement('option');o.value=it.sourceName;o.textContent=it.sourceName;s.appendChild(o)});
  });
}
function obsSetScene(){
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
  if($('obs_remember').checked){
    localStorage.setItem('rc_obs_pw',$('obspw').value||'');
    localStorage.setItem('rc_obs_pw_saved','1');
  }else{
    localStorage.removeItem('rc_obs_pw');localStorage.removeItem('rc_obs_pw_saved');
  }
}

/* ---- boot: hash token + autoload, live events, plans, OBS reconnect ---- */
(function boot(){
  $('track_file').addEventListener('change',e=>{const f=e.target.files&&e.target.files[0];if(f)readTrackFile(f)});
  $('drop_zone').addEventListener('click',pickTrackFile);
  $('drop_zone').addEventListener('dragover',e=>{e.preventDefault();$('drop_zone').className='over'});
  $('drop_zone').addEventListener('dragleave',()=>{$('drop_zone').className=''});
  $('drop_zone').addEventListener('drop',e=>{
    e.preventDefault();$('drop_zone').className='';
    const f=e.dataTransfer&&e.dataTransfer.files&&e.dataTransfer.files[0];
    if(f)readTrackFile(f);
  });
  $('obs_remember').addEventListener('change',obsRememberChange);
  if(localStorage.getItem('rc_obs_pw_saved')==='1'){
    $('obspw').value=localStorage.getItem('rc_obs_pw')||'';
    $('obs_remember').checked=true;
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
      history.replaceState(null,'','/');
      if(params.get('autoload')==='current')loadCurrentLiveEvent();
    }
  }
  poll();  // start live polling only after the hash token has been applied
  refreshLiveEvents();
  refreshPlans();
})();
window.racecamPanel={cmd:cmd,trigger:trigger,enqueue:enqueue,undo:undo,toggleRehearsal:toggleRehearsal,
  refreshLiveEvents:refreshLiveEvents,loadCurrentLiveEvent:loadCurrentLiveEvent,
  applySelectedLiveEvent:applySelectedLiveEvent,postAutoFlags:postAutoFlags,
  refreshPlans:refreshPlans,loadPlanFromServer:loadPlanFromServer,
  obsConnect:obsConnect,obsCheck:obsCheck,obsScenes:obsScenes,obsShot:obsShot,
  sha256:sha256,sha256b64:sha256b64,routePlanner:window.routePlanner};
</script></body></html>]=]

return M
