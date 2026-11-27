-- racecam_http.lua — local HTTP control panel for AMC RaceCam.
-- Non-blocking LuaSocket server: all request work happens on the game thread in short slices.
-- Broadcast-grade features: heartbeat fail-safe, JSONL audit log, engine status passthrough,
-- and an operator panel with OBS WebSocket v5 control, tally, cue queue and rehearsal mode.
local H = {}
-- Resolve the RaceCam data directory without hardcoding a drive letter:
-- the RACECAM_DIR environment variable wins; otherwise candidate relative
-- paths are probed by attempting to create a marker file (io.open append).
local function racecam_dir() return require("RaceCam/path").data_dir() end

local D = racecam_dir()

-- LuaSocket DLLs are installed into ue4ss/Mods/shared/ under the game's
-- Binaries/Win64 root. UE4SS may run Lua with the cwd at either the Win64
-- directory or its parent, so both relative roots are registered.
package.cpath = package.cpath ..
  ";./ue4ss/Mods/shared/?.dll;./ue4ss/Mods/shared/?/?.dll" ..
  ";../ue4ss/Mods/shared/?.dll;../ue4ss/Mods/shared/?/?.dll"

local socket = require("socket")

local function readfile(path)
  local f = io.open(path, "r"); if not f then return nil end
  local c = f:read("*a"); f:close()
  return c and c:gsub("^%s+", ""):gsub("%s+$", "")
end

local server = nil
local pending = {}
local last_result = "idle"

-- Heartbeat fail-safe state: armed by the first authenticated request, so the
-- panel only becomes load-bearing once an operator is actually watching.
local hb_armed = false
local hb_last_seen = 0
local degraded = false
local degraded_reported = false
local timeout_cache = { v = 120, t = 0 }

local function log(s)
  if _G.RACECAM_LOG == 1 then
    local o = io.open(D .. "http.txt", "a"); if o then o:write(s .. "\n"); o:close() end
  end
end

local function jstr(s)
  s = tostring(s or "")
  s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\r\n", " "):gsub("\r", " "):gsub("\n", " "):gsub("\t", " ")
  return s
end

local function active_shot_id()
  local e = _G.RACECAM_SHOTS
  return e and e.active and e.active.id or "none"
end

-- Audit log: one small JSON line per command. Never logs IPs or token values.
local function audit(event, cmd, result)
  local path = D .. "events.jsonl"
  local f = io.open(path, "r")
  if f then
    local pos = f:seek("end")
    if pos and pos > 1048576 then
      f:close()
      pcall(function()
        os.remove(D .. "events.1.jsonl")
        os.rename(path, D .. "events.1.jsonl")
      end)
    else
      f:close()
    end
  end
  local line = '{"ts":"' .. os.date("!%Y-%m-%dT%H:%M:%SZ") .. '","event":"' .. jstr(event) ..
    '","cmd":"' .. jstr(cmd) .. '","result":"' .. jstr(result) ..
    '","active_shot":"' .. jstr(active_shot_id()) .. '"}\n'
  local f = io.open(D .. "events.jsonl", "a")
  if f then f:write(line); f:close() end
end

local function hb_timeout()
  local now = os.time()
  if now - timeout_cache.t > 5 then
    timeout_cache.v = tonumber(readfile(D .. "racecam_timeout.txt")) or 120
    if timeout_cache.v <= 0 then timeout_cache.v = 120 end
    timeout_cache.t = now
  end
  return timeout_cache.v
end

-- Called on every authenticated request; refreshes the heartbeat window.
-- Degraded clears only after the panel has seen the degraded state at least
-- once, so the operator's banner is actually displayed before recovery.
local function touch()
  hb_last_seen = os.time()
  hb_armed = true
  if degraded then
    local core = _G.RACECAM_CORE
    if core and core.running then
      degraded = false
      degraded_reported = false
      last_result = "recovered"
      audit("restored", "heartbeat", "operator back online")
    end
  end
end

-- Fail-safe: if no authenticated request inside the timeout window, stop the
-- shot engine exactly once and flip to degraded until the heartbeat returns.
local function fail_safe_tick()
  if not hb_armed or degraded then return end
  if os.time() - hb_last_seen > hb_timeout() then
    degraded = true
    local e = _G.RACECAM_SHOTS
    if e and type(e.stop) == "function" then
      pcall(function() e:stop() end)
    end
    if _G.RACECAM_CORE and type(_G.RACECAM_CORE.stop) == "function" then
      pcall(function() _G.RACECAM_CORE:stop() end)
    end
    last_result = "FAILSAFE no heartbeat"
    audit("degraded", "failsafe_stop", "no heartbeat for " .. tostring(hb_timeout()) .. "s; shots stopped")
  end
end

local PANEL = [==[<!doctype html><html><head><meta charset="utf-8"><title>AMC RaceCam</title>
<style>
body{font:14px system-ui;background:#111;color:#eee;margin:0;padding:16px}
h1{font-size:18px;margin:0 0 12px}.card{background:#1b1b1b;border:1px solid #333;border-radius:6px;padding:12px;margin-bottom:12px}
button{background:#2b6cb0;border:0;color:#fff;padding:8px 12px;border-radius:4px;cursor:pointer;margin:2px}
button:hover{background:#3182ce}input,select{background:#222;color:#eee;border:1px solid #444;padding:6px;border-radius:4px}
pre{background:#0c0c0c;border:1px solid #333;padding:8px;max-height:220px;overflow:auto;white-space:pre-wrap}
.badge{display:inline-block;padding:6px 14px;border-radius:4px;font-weight:bold;margin-right:8px}
.tally-on-prog{background:#c53030}.tally-on-prev{background:#2f855a}.tally-off{background:#444;color:#aaa}
#banner{display:none;padding:10px;border-radius:4px;margin-bottom:12px;font-weight:bold}
#banner.degraded{display:block;background:#742a2a;color:#fff}
#banner.rehearsal{display:block;background:#975a16;color:#fff}
.kbd{color:#888;font-size:12px;margin-top:6px}
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
</div>
<div class="card">
OBS WebSocket: <input id="obsurl" size="28" value="ws://127.0.0.1:4455">
Password: <input id="obspw" type="password" size="12">
<button onclick="obsConnect()">Connect</button> <button onclick="obsDisc()">Disconnect</button>
<span id="obsst">disconnected</span><br>
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
let tok=sessionStorage.getItem('racecam_tok')||'';$('tok').value=tok;
function save(){tok=$('tok').value;sessionStorage.setItem('racecam_tok',tok)}
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
poll();

/* ---- OBS WebSocket v5 client (obs-websocket protocol) ---- */
/* Password lives only in this page's memory; it is never persisted. */
let obs=null,obsId=0;const obsPend={};
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
</script></body></html>]==]

local function engine_status()
  local e = _G.RACECAM_SHOTS
  if not e then return nil end
  local ok, st = pcall(function() return e:status() end)
  if ok and type(st) == "table" then return st end
  return nil
end

local function id_of(v)
  if type(v) == "table" then return tostring(v.id or v.name or "") end
  return tostring(v)
end

local function idlist(t)
  local q = {}
  for _, v in ipairs(t) do q[#q + 1] = '"' .. jstr(id_of(v)) .. '"' end
  return "[" .. table.concat(q, ",") .. "]"
end

local function speclist(t)
  local q = {}
  for _, v in ipairs(t) do
    if type(v) == "table" then
      local id = '"' .. jstr(tostring(v.id or "")) .. '"'
      q[#q + 1] = v.at_t and ('{"id":' .. id .. ',"at_t":' .. tostring(v.at_t) .. '}') or ('{"id":' .. id .. '}')
    else
      q[#q + 1] = '{"id":"' .. jstr(id_of(v)) .. '"}'
    end
  end
  return "[" .. table.concat(q, ",") .. "]"
end

local function state_json()
  local e = _G.RACECAM_SHOTS
  local st = engine_status()
  local parts = {}
  if degraded then degraded_reported = true end
  local cur = (st and (st.shot or st.current)) or (e and e.active and e.active.id or "none")
  local nxt = st and (st.next_shot or st.next) or nil
  local fov = e and e.last and e.last.fov or 0
  parts[#parts + 1] = '"active_shot":"' .. jstr(id_of(cur)) .. '"'
  parts[#parts + 1] = '"fov":' .. tostring(tonumber(fov) or 0)
  local plan_id = (e and e.plan and e.plan.source and e.plan.source.plan_id) or (e and e.plan and e.plan.name) or "unknown"
  parts[#parts + 1] = '"plan":"' .. jstr(tostring(plan_id)) .. '"'
  if st and st.target_lost ~= nil then parts[#parts + 1] = '"target_lost":' .. tostring(st.target_lost) end
  if st and st.target_lost_for then parts[#parts + 1] = '"target_lost_for":' .. string.format("%.1f", st.target_lost_for) end
  parts[#parts + 1] = '"result":"' .. jstr(last_result) .. '"'
  parts[#parts + 1] = '"last_result":"' .. jstr(last_result) .. '"'
  parts[#parts + 1] = '"degraded":' .. tostring(degraded)
  parts[#parts + 1] = '"running":' .. tostring(_G.RACECAM_CORE and _G.RACECAM_CORE.running and true or false)
  if hb_armed then
    parts[#parts + 1] = '"heartbeat_age":' .. tostring(os.time() - hb_last_seen)
  else
    parts[#parts + 1] = '"heartbeat_age":null'
  end
  parts[#parts + 1] = '"rehearsal":' .. tostring(_G.RACECAM_CORE and _G.RACECAM_CORE.rehearsal and true or false)
  local targets = {}
  if e and type(e.list_targets) == "function" then
    local ok, found = pcall(function() return e:list_targets() end)
    if ok and type(found) == "table" then targets = found end
  end
  parts[#parts + 1] = '"targets":' .. idlist(targets)
  if st then
    if cur ~= nil then parts[#parts + 1] = '"current":"' .. jstr(id_of(cur)) .. '"' end
    if nxt ~= nil then parts[#parts + 1] = '"next":"' .. jstr(id_of(nxt)) .. '"' end
    local cd = tonumber(st.countdown)
    if cd then parts[#parts + 1] = '"countdown":' .. string.format("%.2f", cd) end
    if type(st.queue) == "table" then
      parts[#parts + 1] = '"queue":' .. idlist(st.queue)
      parts[#parts + 1] = '"queue_spec":' .. speclist(st.queue)
    end
    local ids = {}
    if e and e.plan and type(e.plan.shots) == "table" then
      for _, s in ipairs(e.plan.shots) do ids[#ids + 1] = s.id end
    elseif type(st.shots) == "table" then
      ids = st.shots
    end
    if #ids > 0 then parts[#parts + 1] = '"shots":' .. idlist(ids) end
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function json_field(body, key)
  local pat = '"' .. key .. '"%s*:%s*"'
  local _, s = body:find(pat)
  if not s then return nil end
  local i, out = s + 1, {}
  while i <= #body do
    local c = body:sub(i, i)
    if c == '"' then break
    elseif c == '\\' then
      local n = body:sub(i + 1, i + 1)
      if n == "n" then out[#out + 1] = "\n"
      elseif n == "r" then out[#out + 1] = "\r"
      elseif n == "t" then out[#out + 1] = "\t"
      else out[#out + 1] = n end
      i = i + 2
    else
      out[#out + 1] = c
      i = i + 1
    end
  end
  return table.concat(out)
end

local function parse_queue(s)
  local list = {}
  for obj in tostring(s or ""):gmatch("{(.-)}") do
    local id = obj:match('"id"%s*:%s*"([^"]+)"')
    local at = tonumber(obj:match('"at_t"%s*:%s*([%d%.%-]+)'))
    if id then list[#list + 1] = { id = id, at_t = at } end
  end
  if #list > 0 then return list end
  local ids = {}
  for id in tostring(s or ""):gmatch('"([^"]+)"') do ids[#ids + 1] = id end
  if #ids == 0 then
    for id in tostring(s or ""):gmatch("[^%s,%[%]{}:]+") do ids[#ids + 1] = id end
  end
  return ids
end

local function dispatch(item)
  local e, core = _G.RACECAM_SHOTS, _G.RACECAM_CORE
  if not e or not core then return "NOENGINE" end
  local cmd, args = item.cmd, item.args or ""
  if cmd == "start" then e:signal("start"); return "started"
  elseif cmd == "stop" then core.stop(); return "stopped"
  elseif cmd == "arm" then
    if core.running then return "already armed" end
    local ok, r = pcall(function() return core.restart() end)
    if ok then return "rearmed " .. tostring(r or "ok") end
    return "ERR " .. tostring(r)
  elseif cmd == "rehearsal" then
    core.rehearsal = (args == "on" or args == "true" or args == "1")
    e:log("REHEARSAL " .. (core.rehearsal and "on" or "off"))
    return core.rehearsal and "rehearsal on" or "rehearsal off"
  elseif cmd == "trigger" then return e:manual(args)
  elseif cmd == "select" then
    local name_err = "no target API"
    if type(e.set_target_by_name) == "function" then
      local ok, selok, msg = pcall(function() return e:set_target_by_name(args) end)
      if ok and selok then return tostring(msg or ("target " .. args)) end
      name_err = ok and tostring(msg) or tostring(selok)
    end
    local idx = tonumber(args)
    if idx and type(e.set_target_by_index) == "function" then
      local r = e:set_target_by_index(idx)
      if r and not tostring(r):match("^no pawn") then return tostring(r) end
      name_err = tostring(r)
    end
    return "ERR " .. name_err
  elseif cmd == "next" then
    if type(e.queue_next) == "function" then
      local ok, r = pcall(function() return e:queue_next() end)
      if ok then return tostring(r or "queued next") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "queue" then
    if type(e.queue) == "function" then
      local ok, r = pcall(function() return e:queue(parse_queue(args)) end)
      if ok then return tostring(r or "queued") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "queue_clear" then
    if type(e.queue_clear) == "function" then
      local ok, r = pcall(function() return e:queue_clear() end)
      if ok then return tostring(r or "queue cleared") end
      return "ERR " .. tostring(r)
    end
    return "NOQUEUE"
  elseif cmd == "status" then return "ok"
  end
  return "unknown " .. jstr(cmd)
end

local function make_response(req)
  local token = readfile(D .. "racecam_token.txt")
  local code, body, ctype = 400, '{"error":"not found"}', "application/json"
  local authed = false
  if req.method == "GET" and (req.path == "/" or req.path == "/index.html") then
    code, body, ctype = 200, PANEL, "text/html"
  elseif not token or token == "" or req.headers["x-racecam-token"] ~= token then
    body = '{"error":"bad token"}'
  elseif req.method == "GET" and req.path == "/api/state" then
    authed = true
    touch()
    code, body = 200, state_json()
  elseif req.method == "POST" and req.path == "/api/command" then
    authed = true
    touch()
    local cmd = json_field(req.body, "cmd") or ""
    local args = json_field(req.body, "args") or ""
    local ok, result = pcall(dispatch, { cmd = cmd, args = args })
    last_result = ok and tostring(result) or ("ERR " .. tostring(result))
    log("CMD " .. cmd .. " " .. args .. " -> " .. last_result)
    audit("command", cmd, last_result)
    code, body = 200, '{"status":"' .. jstr(last_result) .. '"}'
  end
  local reason = code == 200 and "OK" or "Bad Request"
  return "HTTP/1.1 " .. code .. " " .. reason .. "\r\nContent-Type: " .. ctype ..
    "\r\nContent-Length: " .. #body .. "\r\nConnection: close\r\n\r\n" .. body
end

local function parse_request(buf)
  local head, body = buf:match("^(.-)\r?\n\r?\n(.*)$")
  if not head then return nil, nil end
  local headers = {}
  for line in head:gmatch("[^\r\n]+") do
    local k, v = line:match("^([^:]+):%s*(.+)$")
    if k then headers[k:lower()] = v end
  end
  local method, path = head:match("^(%u+)%s+(%S+)")
  local len = tonumber(headers["content-length"] or "0") or 0
  if #body < len then return nil, headers end
  return { method = method, path = path, headers = headers, body = body:sub(1, len) }, headers
end

local function pump(conn)
  local skt = conn.skt
  skt:settimeout(0)

  if not conn.response then
    local data, err, last = skt:receive(4096)
    if data and data ~= "" then conn.buf = conn.buf .. data
    elseif last and last ~= "" then conn.buf = conn.buf .. last end
    -- Honour Expect: 100-continue on the first tick that has the headers,
    -- before parse_request runs, so the client sends its body immediately.
    if not conn.expect_done and conn.buf:find("\r\n\r\n", 1, true) then
      local head = conn.buf:match("^(.-)\r?\n\r?\n")
      if head and head:lower():find("expect:%s*100%-continue") then
        pcall(function() skt:send("HTTP/1.1 100 Continue\r\n\r\n") end)
      end
      conn.expect_done = true
    end
    local req, headers = parse_request(conn.buf)
    if req then
      conn.response = make_response(req)
      conn.buf = ""
    elseif headers and os.time() - conn.t0 > 3 then
      return nil
    end
  end

  if conn.response then
    local sent, err, last = skt:send(conn.response)
    local n = tonumber(sent) or tonumber(last) or 0
    if n > 0 then conn.response = conn.response:sub(n + 1) end
    if conn.response == "" then skt:close(); return nil end
  end

  if os.time() - conn.t0 > 5 then skt:close(); return nil end
  return conn
end

function H.tick()
  if not server then return false end
  for _ = 1, 8 do
    local skt = server:accept()
    if not skt then break end
    pending[#pending + 1] = { skt = skt, buf = "", t0 = os.time() }
  end
  for i = #pending, 1, -1 do
    local ok, alive = pcall(pump, pending[i])
    if not ok then log("PUMPERR " .. tostring(alive)) end
    if not ok or not alive then
      pcall(function() pending[i].skt:close() end)
      table.remove(pending, i)
    end
  end
  fail_safe_tick()
  return true
end

function H.stop()
  if server then pcall(function() server:close() end); server = nil end
  for _, c in ipairs(pending) do pcall(function() c.skt:close() end) end
  pending = {}
  _G.RACECAM_HTTP = nil
  return "stopped"
end

function H.start()
  if server then return "already started" end
  local host = readfile(D .. "racecam_bind.txt") or "127.0.0.1"
  local ok, s = pcall(function()
    local b = assert(socket.bind(host, 8767))
    b:setoption("reuseaddr", true)
    b:settimeout(0)
    return b
  end)
  if not ok then log("BIND " .. tostring(s)); return "BIND " .. tostring(s) end
  server = s
  _G.RACECAM_HTTP = H
  LoopInGameThreadWithDelay(100, H.tick)
  log("HTTP local panel on " .. host .. ":8767 token=" .. tostring(readfile(D .. "racecam_token.txt") ~= nil) ..
    " failsafe_timeout=" .. tostring(hb_timeout()) .. "s")
  return "listening " .. host .. ":8767"
end

return H
