-- RaceCam/overlay_ui.lua — self-contained OBS Browser Source for live standings.
--
-- Exports M.html() (and M.HTML) with a zero-dependency HTML/CSS/JS timing
-- tower. http.lua serves it unauthenticated at GET /overlay/standings; the
-- page polls the strictly read-only GET /api/standings every 500 ms.
-- No external CDN, fonts, or scripts; transparent background for OBS.
local M = {}

M.HTML = [==[<!doctype html><html><head><meta charset="utf-8">
<title>AMC Live Standings</title>
<style>
  :root{--ink:#f4f7fa;--muted:#97a6b8;--line:rgba(255,255,255,.12);
    --panel:rgba(10,14,20,.88);--gold:#f5c542;--silver:#cbd5e1;--bronze:#d98a4e;
    --green:#46d17f;--red:#f0616d;--purple:#b794f4}
  *{box-sizing:border-box}
  html,body{background:transparent;margin:0;padding:0;overflow:hidden;
    font-family:system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
    font-variant-numeric:tabular-nums;color:var(--ink)}
  #tower{position:absolute;top:0;left:0;width:420px;padding:10px 12px;
    border-radius:10px;background:var(--panel);border:1px solid var(--line);
    box-shadow:0 8px 28px rgba(0,0,0,.45);opacity:1;
    transition:opacity 350ms ease;font-size:14px}
  #tower.right{left:auto;right:0}
  #tower.compact{font-size:12px;padding:7px 9px}
  #tower.hidden{opacity:0;pointer-events:none}
  .hd{display:flex;align-items:center;gap:8px;padding:0 3px 8px;
    border-bottom:1px solid var(--line);margin-bottom:6px}
  .ttl{flex:1 1 auto;min-width:0;overflow:hidden;text-overflow:ellipsis;
    white-space:nowrap;font-weight:700;font-size:.92em;letter-spacing:.2px}
  .badge{flex:0 0 auto;padding:3px 7px;border-radius:4px;font-size:.72em;
    font-weight:800;letter-spacing:.8px;background:#334155;color:#dbe4ef}
  .badge.start{background:#7a5310;color:#ffe6a8}
  .badge.live{background:#8a1f27;color:#fff}
  .badge.live:before{content:"";display:inline-block;width:6px;height:6px;
    border-radius:50%;background:#ff5a5a;margin-right:5px;vertical-align:1px}
  .badge.finish{background:#125b45;color:#b7f7d6}
  .lap{flex:0 0 auto;font-size:.78em;color:var(--muted);font-weight:700;
    letter-spacing:.3px;white-space:nowrap}
  .lap.final{color:var(--gold)}
  #rows{display:flex;flex-direction:column;gap:3px;min-height:4px}
  .row{display:flex;align-items:center;gap:8px;min-height:30px;padding:3px 7px;
    border-radius:5px;background:rgba(255,255,255,.035);
    transition:transform 300ms cubic-bezier(.2,.7,.3,1),background 200ms ease;
    will-change:transform}
  .compact .row{min-height:23px;padding:2px 6px}
  .row.target{background:rgba(88,166,255,.16);
    box-shadow:inset 3px 0 0 #58a6ff}
  .row.pinned{border-top:1px dashed var(--line);border-radius:0 0 5px 5px;
    margin-top:4px;background:rgba(88,166,255,.10)}
  .pos{flex:0 0 27px;text-align:center;font-weight:800;font-size:.86em;
    padding:2px 0;border-radius:4px;background:#283140;color:#cbd5e1}
  .pos.p1{background:var(--gold);color:#2b2000}
  .pos.p2{background:var(--silver);color:#202833}
  .pos.p3{background:var(--bronze);color:#2a1608}
  .pos.dq{background:#5a2323;color:#f0b8b8}
  .nm{flex:1 1 auto;min-width:0;overflow:hidden;text-overflow:ellipsis;
    white-space:nowrap;font-weight:600}
  .tag{color:var(--muted);font-weight:500;font-size:.82em}
  .delta{flex:0 0 auto;font-size:.74em;font-weight:800;min-width:24px;text-align:right}
  .delta.up{color:var(--green)}.delta.down{color:var(--red)}
  .metric{flex:0 0 auto;min-width:68px;text-align:right;font-size:.84em;
    font-weight:700;color:#d5e0ed;white-space:nowrap}
  .metric.win{color:var(--green)}
  .metric.bad{color:var(--red)}
  .metric.fl{color:var(--purple)}
  .fl-dot{display:inline-block;width:6px;height:6px;border-radius:50%;
    background:var(--purple);margin-right:5px;vertical-align:1px}
  .ft{display:flex;align-items:center;gap:7px;margin-top:7px;padding:6px 3px 0;
    border-top:1px solid var(--line);font-size:.78em;color:var(--muted)}
  .fl-badge{background:#4c3a75;color:#e6d9ff;border-radius:3px;padding:2px 5px;
    font-weight:800;letter-spacing:.5px}
  .wait{padding:18px 10px;text-align:center;color:var(--muted);
    font-size:.85em;letter-spacing:.4px}
</style></head><body>
<div id="tower"><div class="hd"><span id="ev_title" class="ttl">AMC LIVE TIMING</span>
<span id="ev_state" class="badge">LOBBY</span><span id="lap" class="lap">—</span></div>
<div id="rows"></div><div id="footer" class="ft" style="display:none"></div></div>
<script>
(function(){
  'use strict';
  var qs=new URLSearchParams((location.search||'').replace(/^\?/,''));
  function qnum(k,d,min){var v=parseFloat(qs.get(k));return isFinite(v)&&v>=min?v:d}
  var mode=qs.get('mode')||'gap';
  if(['gap','best','lap'].indexOf(mode)<0)mode='gap';
  var CFG={top:Math.max(1,Math.floor(qnum('top',16,1))),mode:mode,
    scale:qnum('scale',1,.25),pos:qs.get('pos')==='right'?'right':'left',
    compact:qs.get('compact')==='1',always:qs.get('always')==='1',
    title:qs.get('title')||'',event:qs.get('event')||''};
  var $=function(id){return document.getElementById(id)};
  var root=$('tower');
  if(root){
    root.className=(CFG.pos==='right'?'right ':'')+(CFG.compact?'compact':'');
    root.style.transform='scale('+CFG.scale+')';
    root.style.transformOrigin=CFG.pos==='right'?'top right':'top left';
  }
  function esc(s){return String(s===null||s===undefined?'':s)
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
    .replace(/"/g,'&quot;').replace(/'/g,'&#39;')}
  function fmtBest(sec){
    var v=Number(sec);if(!isFinite(v)||v<=0)return '';
    var m=Math.floor(v/60),r=v-m*60;
    return m+':'+(r<10?'0':'')+r.toFixed(2);
  }
  function fmtGap(row,leader,waypointCount){
    if(!row)return '';
    if(row.disqualified)return 'DQ';
    if(row.finished)return 'FIN';
    if(!leader||Number(row.rank)<=1)return 'LEADER';
    var laps=Number(row.laps)||0,lp=Number(leader.laps)||0;
    if(laps<lp){var d=lp-laps;return '+'+d+(d===1?' LAP':' LAPS')}
    if(laps>lp)return 'LEADER';
    var delta=(Number(row.last_sec_s)||0)-(Number(leader.last_sec_s)||0);
    var sec=Number(row.section)||0,lsec=Number(leader.section)||0;
    if(sec===lsec&&delta>0&&delta<300)return '+'+delta.toFixed(1)+'s';
    var total=Number(waypointCount)||0;
    if(sec>0&&total>0)return 'S'+sec+'/'+total;
    return '-'+Math.max(1,lsec-sec)+' CP';
  }
  function fastestLap(rows){
    var best=null,t=Infinity;
    (rows||[]).forEach(function(r){
      var v=Number(r&&r.best_lap_s);
      if(!r||r.disqualified||!isFinite(v)||v<=0)return;
      if(v<t){t=v;best=r.name}
    });
    return best;
  }
  function stateBadge(ev){
    if(!ev)return {label:'LOBBY',cls:''};
    if(ev.state===3)return {label:'FINISH',cls:'finish'};
    if(ev.state===2)return {label:'LIVE',cls:'live'};
    if(ev.in_countdown||ev.state===1)return {label:'START',cls:'start'};
    return {label:'LOBBY',cls:''};
  }
  function lapLabel(ev,leader){
    if(!ev)return {text:'—',final:false};
    var total=Number(ev.num_laps)||0;
    var laps=leader?(Number(leader.laps)||0):0;
    var cur=Math.min(laps+1,total>0?total:laps+1);
    return {text:'LAP '+cur+(total>0?' / '+total:''),final:total>0&&laps+1===total};
  }
  function buildRows(payload){
    var ev=payload&&payload.event;
    var rows=(ev&&Array.isArray(ev.standings))?ev.standings.slice():[];
    if(!rows.length)return {rows:[],leader:null,fl:null,target:''};
    rows.sort(function(a,b){
      var ad=!!a.disqualified,bd=!!b.disqualified;
      if(ad!==bd)return ad?1:-1;
      return (Number(a.rank)||0)-(Number(b.rank)||0);
    });
    var leader=null;
    for(var i=0;i<rows.length;i++){
      if(!rows[i].disqualified&&Number(rows[i].rank)===1){leader=rows[i];break}
    }
    if(!leader)for(var j=0;j<rows.length;j++){if(!rows[j].disqualified){leader=rows[j];break}}
    return {rows:rows,leader:leader,fl:fastestLap(rows),
      target:String(payload&&payload.target_name||'')};
  }
  var rankHistory={},deltaInfo={},lastRows=[],lastPayload=null,panelVisible=true;
  function applySnapshot(payload){
    var snap=buildRows(payload),ev=payload&&payload.event;
    var now=Date.now(),fl=snap.fl,wpc=ev&&ev.waypoint_count;
    lastPayload=payload||null;
    lastRows=snap.rows.map(function(r){
      var name=String(r.name||''),prev=rankHistory[name],rank=Number(r.rank)||0;
      if(prev!==undefined&&prev!==rank)deltaInfo[name]={v:prev-rank,until:now+4000};
      rankHistory[name]=rank;
      var d=deltaInfo[name],delta=(d&&d.until>now)?d.v:0;
      var metric='';
      if(CFG.mode==='best'){
        metric=fmtBest(r.best_lap_s)||'—';
      }else if(CFG.mode==='lap'){
        metric='L'+(Number(r.laps)||0)+' · S'+(Number(r.section)||0)+
          '/'+(Number(wpc)||0);
      }else{
        metric=fmtGap(r,snap.leader,wpc);
      }
      var cls=metric==='FIN'||metric==='LEADER'?'win':
        (metric==='DQ'?'bad':(CFG.mode==='best'&&name===fl?'fl':''));
      return {name:name,rank:rank,laps:Number(r.laps)||0,metric:metric,
        metricClass:cls,delta:delta,
        isTarget:!!snap.target&&name===snap.target,
        pinned:false,finished:!!r.finished,disqualified:!!r.disqualified,
        best_lap_s:Number(r.best_lap_s)||0,best:Number(r.best_lap_s)||0};
    });
    panelVisible=!!(payload&&payload.visible!==false&&ev&&lastRows.length>0);
    return lastRows.slice();
  }
  function rowHtml(r){
    var posCls=r.disqualified?'dq':(r.rank===1?'p1':(r.rank===2?'p2':(r.rank===3?'p3':'')));
    var posLabel=r.disqualified?'DQ':String(r.rank||'—');
    var delta=r.delta>0?'▲'+r.delta:(r.delta<0?'▼'+Math.abs(r.delta):'');
    var dCls=r.delta>0?'up':(r.delta<0?'down':'');
    var flDot=(CFG.mode==='best'&&r.metricClass==='fl')?'<i class="fl-dot"></i>':'';
    var nm=esc(r.name),tag='';
    var t=nm.match(/^(.{1,12})\s*(\[[^\]]{1,12}\])$/);
    if(t)nm=esc(t[1])+' <span class="tag">'+esc(t[2])+'</span>';
    return '<div class="row'+(r.isTarget?' target':'')+(r.pinned?' pinned':'')+
      '" data-name="'+esc(r.name)+'">'+
      '<span class="pos '+posCls+'">'+posLabel+'</span>'+
      '<span class="nm">'+nm+'</span>'+
      (delta?'<span class="delta '+dCls+'">'+delta+'</span>':'')+
      '<span class="metric '+r.metricClass+'">'+flDot+esc(r.metric)+'</span></div>';
  }
  function render(payload){
    if(!root)return {rows:[],visible:false};
    var old={};
    var prev=root.querySelectorAll?root.querySelectorAll('[data-name]'):[];
    for(var k=0;k<prev.length;k++){
      var n=prev[k].getAttribute?prev[k].getAttribute('data-name'):'';
      if(n&&prev[k].getBoundingClientRect)old[n]=prev[k].getBoundingClientRect().top;
    }
    var rows=applySnapshot(payload),ev=payload&&payload.event;
    var shown=rows.slice(0,CFG.top),pinned=null;
    if(rows.length>CFG.top){
      for(var p=CFG.top;p<rows.length;p++){
        if(rows[p].isTarget){pinned=rows[p];pinned.pinned=true;break}
      }
    }
    var html=shown.map(rowHtml).join('');
    if(pinned)html+=rowHtml(pinned);
    if(!rows.length){
      html='<div class="wait">'+(CFG.always?'WAITING FOR LIVE EVENT — AMC TIMING Tower READY':
        'NO ACTIVE EVENT')+'</div>';
    }
    $('rows').innerHTML=html;
    var badge=stateBadge(ev),lap=lapLabel(ev,rows[0]&&rows[0].rank===1?rows[0]:null);
    var st=$('ev_state');st.className='badge '+badge.cls;st.textContent=badge.label;
    var lp=$('lap');lp.className='lap'+(lap.final?' final':'');
    lp.textContent=(lap.final?'FINAL LAP · ':'')+lap.text;
    var title=CFG.title||(ev&&ev.event_name)||'AMC LIVE TIMING';
    $('ev_title').textContent=title;
    var fl=fastestLap((ev&&ev.standings)||rows),ft=$('footer');
    if(fl){
      ft.style.display='';
      ft.innerHTML='<span class="fl-badge">FL</span><span>'+esc(fl)+'</span><span>'+
        fmtBest(bestOf(rows,fl))+'</span>';
    }else{ft.style.display='none';ft.innerHTML=''}
    var visible=panelVisible||CFG.always;
    root.className=(CFG.pos==='right'?'right ':'')+(CFG.compact?'compact ':'')+
      (visible?'':'hidden');
    root.style.opacity=visible?'1':'0';
    // FLIP: invert each keyed row to its old screen position, then play it
    // forward on the next frame so overtakes slide instead of snapping.
    var nowEls=root.querySelectorAll?root.querySelectorAll('[data-name]'):[];
    for(var i=0;i<nowEls.length;i++){
      var el=nowEls[i],n2=el.getAttribute?el.getAttribute('data-name'):'';
      if(!el.style||old[n2]===undefined||!el.getBoundingClientRect)continue;
      var dy=old[n2]-el.getBoundingClientRect().top;
      if(!dy)continue;
      el.style.transition='none';
      el.style.transform='translateY('+dy+'px)';
      (function(node){
        if(typeof requestAnimationFrame==='function')requestAnimationFrame(function(){
          node.style.transition='';
          node.style.transform='translateY(0)';
        });
      })(el);
    }
    return {rows:rows,visible:visible};
  }
  function bestOf(rows,name){
    for(var i=0;i<rows.length;i++)if(rows[i].name===name)return rows[i].best_lap_s;
    return 0;
  }
  var busy=false,delay=500,timer=null;
  async function poll(){
    if(busy)return false;
    busy=true;
    var url='/api/standings'+(CFG.event?('?event='+encodeURIComponent(CFG.event)):'');
    try{
      var res=await fetch(url,{cache:'no-store'});
      if(!res.ok)throw new Error('standings http '+res.status);
      var j=await res.json();
      delay=500;
      render(j);
    }catch(e){
      delay=Math.min(2000,delay*2);
      if(CFG.always)render(null);
    }finally{
      busy=false;
      timer=setTimeout(poll,delay);
    }
    return true;
  }
  window.rcOverlay={cfg:CFG,fmtBest:fmtBest,fmtGap:fmtGap,fastestLap:fastestLap,
    stateBadge:stateBadge,lapLabel:lapLabel,buildRows:buildRows,
    applySnapshot:applySnapshot,render:render,poll:poll,
    getRows:function(){return lastRows.slice()},getPayload:function(){return lastPayload},
    getDelay:function(){return delay}};
  render(null);
  poll();
})();
</script></body></html>]==]

function M.html()
  return M.HTML
end

return M
