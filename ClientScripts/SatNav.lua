--- SatNav PoC — 3D browser widget floating in world space
--- Spawns a UWebBrowser inside a UWidgetComponent in front of the player.
--- Toggle with /satnav or Ctrl+Shift+N

local UEHelpers = require("UEHelpers")

local SatNav = {}

-- State
local satnavActor = CreateInvalidObject() ---@cast satnavActor AActor
local widgetComp = CreateInvalidObject() ---@cast widgetComp UWidgetComponent
local browser = CreateInvalidObject()    ---@cast browser UWebBrowser
local updateLoopActive = false

-- ─── Satnav HTML ────────────────────────────────────────────────

local SATNAV_HTML = [[
<!DOCTYPE html>
<html>
<head>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    background: rgba(8, 12, 20, 0.92);
    font-family: 'Segoe UI', 'Arial', sans-serif;
    color: #fff;
    overflow: hidden;
    width: 100%; height: 100%;
  }
  #wrap {
    width: 100%; height: 100%;
    position: relative;
    border: 2px solid rgba(0, 200, 255, 0.3);
    border-radius: 6px;
    overflow: hidden;
  }
  canvas { display: block; width: 100%; height: 100%; }
  .hud-overlay {
    position: absolute; top: 0; left: 0;
    width: 100%; height: 100%;
    pointer-events: none;
  }
  .heading-bar {
    position: absolute; top: 8px; left: 50%;
    transform: translateX(-50%);
    background: rgba(0, 0, 0, 0.6);
    padding: 3px 16px;
    border-radius: 4px;
    font-size: 16px; font-weight: 600;
    letter-spacing: 2px;
    color: #0cf;
    border: 1px solid rgba(0, 200, 255, 0.2);
  }
  .speed-box {
    position: absolute; bottom: 8px; right: 10px;
    text-align: right;
  }
  .speed-value {
    font-size: 32px; font-weight: 700;
    color: #fff;
    line-height: 1;
  }
  .speed-unit {
    font-size: 11px; color: #68a;
    letter-spacing: 1px;
  }
  .coord-box {
    position: absolute; bottom: 8px; left: 10px;
    font-size: 10px; color: #456;
    font-family: monospace;
  }
  .status-dot {
    position: absolute; top: 10px; right: 12px;
    width: 8px; height: 8px;
    background: #0f0; border-radius: 50%;
    box-shadow: 0 0 6px #0f0;
    animation: pulse 2s infinite;
  }
  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
  }
</style>
</head>
<body>
<div id="wrap">
  <canvas id="nav"></canvas>
  <div class="hud-overlay">
    <div class="heading-bar" id="heading">N 0°</div>
    <div class="status-dot"></div>
    <div class="speed-box">
      <div class="speed-value" id="speed">0</div>
      <div class="speed-unit">KM/H</div>
    </div>
    <div class="coord-box" id="coords">0, 0</div>
  </div>
</div>

<script>
  const canvas = document.getElementById('nav');
  const ctx = canvas.getContext('2d');

  let px = 0, py = 0, yaw = 0, spd = 0;
  // Track trail of recent positions
  const trail = [];
  const MAX_TRAIL = 80;

  function updatePlayer(x, y, heading, speed) {
    px = x; py = y; yaw = heading; spd = speed;
    trail.push({x: px, y: py});
    if (trail.length > MAX_TRAIL) trail.shift();
    render();
  }

  function render() {
    const W = canvas.width, H = canvas.height;
    const cx = W / 2, cy = H / 2;

    // Clear
    ctx.fillStyle = '#080c14';
    ctx.fillRect(0, 0, W, H);

    ctx.save();
    ctx.translate(cx, cy);
    // Rotate map so heading is always up
    const rad = -yaw * Math.PI / 180;
    ctx.rotate(rad);

    // Grid
    const gridSize = 40;
    const gridRange = 500;
    ctx.strokeStyle = 'rgba(0, 160, 220, 0.08)';
    ctx.lineWidth = 0.5;
    const ox = (px % gridSize);
    const oy = (py % gridSize);
    for (let i = -gridRange; i <= gridRange; i += gridSize) {
      ctx.beginPath();
      ctx.moveTo(i - ox, -gridRange - oy);
      ctx.lineTo(i - ox, gridRange - oy);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(-gridRange - ox, i - oy);
      ctx.lineTo(gridRange - ox, i - oy);
      ctx.stroke();
    }

    // Cardinal markers
    const markerDist = 120;
    ctx.font = '14px Segoe UI';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    const cardinals = [
      {label: 'N', dx: 0, dy: -markerDist, color: '#f44'},
      {label: 'E', dx: markerDist, dy: 0, color: '#68a'},
      {label: 'S', dx: 0, dy: markerDist, color: '#68a'},
      {label: 'W', dx: -markerDist, dy: 0, color: '#68a'},
    ];
    cardinals.forEach(c => {
      ctx.fillStyle = c.color;
      ctx.fillText(c.label, c.dx, c.dy);
    });

    // Trail
    if (trail.length > 1) {
      ctx.strokeStyle = 'rgba(0, 200, 255, 0.3)';
      ctx.lineWidth = 2;
      ctx.beginPath();
      for (let i = 0; i < trail.length; i++) {
        const dx = trail[i].x - px;
        const dy = trail[i].y - py;
        // UE: X=forward, Y=right — canvas: X=right, Y=down
        const sx = dy * 0.15;
        const sy = -dx * 0.15;
        if (i === 0) ctx.moveTo(sx, sy);
        else ctx.lineTo(sx, sy);
      }
      ctx.stroke();
    }

    ctx.restore();

    // Player chevron (always centered, pointing up)
    ctx.save();
    ctx.translate(cx, cy);
    ctx.fillStyle = '#0cf';
    ctx.shadowColor = '#0cf';
    ctx.shadowBlur = 10;
    ctx.beginPath();
    ctx.moveTo(0, -14);
    ctx.lineTo(-9, 10);
    ctx.lineTo(0, 4);
    ctx.lineTo(9, 10);
    ctx.closePath();
    ctx.fill();
    ctx.restore();

    // Range rings
    ctx.save();
    ctx.translate(cx, cy);
    ctx.strokeStyle = 'rgba(0, 200, 255, 0.06)';
    ctx.lineWidth = 1;
    [60, 120].forEach(r => {
      ctx.beginPath();
      ctx.arc(0, 0, r, 0, Math.PI * 2);
      ctx.stroke();
    });
    ctx.restore();

    // HUD text
    const dirs = ['N','NE','E','SE','S','SW','W','NW'];
    let normYaw = ((yaw % 360) + 360) % 360;
    const idx = Math.round(normYaw / 45) % 8;
    document.getElementById('heading').textContent =
      dirs[idx] + ' ' + Math.round(normYaw) + '\u00B0';
    document.getElementById('speed').textContent = Math.round(spd);
    document.getElementById('coords').textContent =
      Math.round(px) + ', ' + Math.round(py);
  }

  // Init
  canvas.width = 400; canvas.height = 300;
  render();
</script>
</body>
</html>
]]

-- ─── Core Logic ─────────────────────────────────────────────────

---Spawn the satnav floating in front of the player
function SatNav.Show()
  if satnavActor:IsValid() then
    LogOutput("INFO", "SatNav already active")
    return
  end

  ExecuteInGameThread(function()
    local PC = GetMyPlayerController()
    if not PC:IsValid() then
      LogOutput("ERROR", "No PlayerController for SatNav")
      return
    end

    local pawn = PC.Pawn
    if not pawn:IsValid() then
      LogOutput("ERROR", "No Pawn for SatNav")
      return
    end

    -- Find classes
    local WebBrowserClass = StaticFindObject("/Script/WebBrowserWidget.WebBrowser")
    if not WebBrowserClass or not WebBrowserClass:IsValid() then
      LogOutput("ERROR", "UWebBrowser class not found — CEF not available")
      return
    end

    local WidgetCompClass = StaticFindObject("/Script/UMG.WidgetComponent")
    if not WidgetCompClass or not WidgetCompClass:IsValid() then
      LogOutput("ERROR", "UWidgetComponent class not found")
      return
    end

    -- Spawn a simple actor to host the widget
    local world = pawn:GetWorld()
    local actorClass = StaticFindObject("/Script/Engine.Actor")

    -- Position: 3 meters in front, 1.5m up from the player
    local camMgr = PC.PlayerCameraManager
    local camLoc = camMgr:GetCameraLocation()
    local camRot = camMgr:GetCameraRotation()
    local KML = UEHelpers.GetKismetMathLibrary()
    local forward = KML:GetForwardVector(camRot)
    local spawnOffset = KML:Multiply_VectorFloat(forward, 300.0) -- 3m in UE units
    local spawnLoc = KML:Add_VectorVector(camLoc, spawnOffset)
    spawnLoc.Z = spawnLoc.Z + 50.0 -- slightly above eye level

    -- Spawn actor
    local spawnTransform = {}
    spawnTransform.Translation = spawnLoc
    spawnTransform.Rotation = { W = 1, X = 0, Y = 0, Z = 0 }
    spawnTransform.Scale3D = { X = 1, Y = 1, Z = 1 }

    satnavActor = world:SpawnActor(actorClass, spawnTransform)
    if not satnavActor:IsValid() then
      LogOutput("ERROR", "Failed to spawn SatNav actor")
      return
    end
    LogOutput("INFO", "SatNav actor spawned at %.0f, %.0f, %.0f",
      spawnLoc.X, spawnLoc.Y, spawnLoc.Z)

    -- Add WidgetComponent
    widgetComp = satnavActor:AddComponentByClass(
      WidgetCompClass, false, spawnTransform, false
    )

    if not widgetComp:IsValid() then
      LogOutput("ERROR", "Failed to create WidgetComponent")
      satnavActor:K2_DestroyActor()
      satnavActor = CreateInvalidObject()
      return
    end

    -- Configure the WidgetComponent
    widgetComp:SetWidgetSpace(1)                            -- World
    widgetComp:SetDrawSize({ X = 400, Y = 300 })
    widgetComp:SetTickWhenOffscreen(true)
    widgetComp:SetTwoSided(false)
    widgetComp:SetBackgroundColor({ R = 0, G = 0, B = 0, A = 0 })

    widgetComp:RegisterComponent()
    LogOutput("INFO", "WidgetComponent created and registered")

    -- Create the WebBrowser widget
    browser = StaticConstructObject(WebBrowserClass, PC, FName("SatNavBrowser"))
    if browser and browser:IsValid() then
      browser.bSupportsTransparency = true
      browser:LoadString(SATNAV_HTML, "about:satnav")
      widgetComp:SetWidget(browser)
      LogOutput("INFO", "WebBrowser loaded with SatNav HTML")
    else
      LogOutput("ERROR", "Failed to create UWebBrowser instance")
    end

    -- Face the widget toward the camera
    local facingRot = camRot
    -- Flip yaw 180° so the front faces the player
    facingRot.Yaw = facingRot.Yaw + 180.0
    facingRot.Pitch = 0
    facingRot.Roll = 0
    satnavActor:K2_SetActorRotation(facingRot, false)

    -- Start position update loop
    SatNav.StartUpdateLoop()
  end)
end

---Remove the satnav
function SatNav.Hide()
  updateLoopActive = false

  ExecuteInGameThread(function()
    if satnavActor:IsValid() then
      satnavActor:K2_DestroyActor()
      LogOutput("INFO", "SatNav destroyed")
    end
    satnavActor = CreateInvalidObject()
    widgetComp = CreateInvalidObject()
    browser = CreateInvalidObject()
  end)
end

---Toggle satnav visibility
function SatNav.Toggle()
  if satnavActor:IsValid() then
    SatNav.Hide()
  else
    SatNav.Show()
  end
end

---Start the position update loop
function SatNav.StartUpdateLoop()
  if updateLoopActive then return end
  updateLoopActive = true

  LoopAsync(100, function() -- ~10 fps updates
    if not updateLoopActive then return true end -- stop loop
    if not browser:IsValid() then return true end

    local PC = GetMyPlayerController()
    if not PC:IsValid() then return false end -- keep trying

    local pawn = PC.Pawn
    if not pawn:IsValid() then return false end

    local pos = pawn:K2_GetActorLocation()
    local vel = pawn:GetVelocity()
    local rot = PC:GetControlRotation()

    -- Speed in km/h (UE units are cm, velocity is cm/s)
    local speed = math.sqrt(vel.X * vel.X + vel.Y * vel.Y) * 0.036

    -- Push to browser
    local js = string.format(
      "updatePlayer(%f, %f, %f, %f)",
      pos.X, pos.Y, rot.Yaw, speed
    )
    browser:ExecuteJavascript(js)

    return false -- keep looping
  end)
end

return SatNav
