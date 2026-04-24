--- TeleportWidget — Paginated teleport list attached to HUD
--- Shows on TAB, polls button presses via LoopAsync (no delegates)
--- Fetches locations from API, falls back to hardcoded list

local TeleportWidget = {}
local json = require("JsonParser")
local http = require("socket.http")
local ltn12 = require("ltn12")

-- State
local isBuilt = false
local isVisible = false
local rootPanel = CreateInvalidObject() ---@cast rootPanel UBorder
local pageLabel = CreateInvalidObject() ---@cast pageLabel UTextBlock
local buttons = {}      ---@type UButton[]  -- 8 item buttons
local navPrev = CreateInvalidObject() ---@cast navPrev UButton
local navNext = CreateInvalidObject() ---@cast navNext UButton

-- Data
local points = {}       ---@type {name:string}[]
local currentPage = 1
local ITEMS_PER_PAGE = 8

-- Config
local WIDGET_W = 300
local WIDGET_H = 420
local API_URL = "https://server.aseanmotorclub.com/api/v1/teleports/"

-- Visibility
local VIS_VISIBLE = 0
local VIS_COLLAPSED = 1

-- Colors
local BG_COLOR = {R=0.04, G=0.04, B=0.08, A=0.95}
local BTN_BG = {R=0.0, G=0.55, B=0.85, A=1.0}
local NAV_BG = {R=0.2, G=0.2, B=0.25, A=1.0}
local TEXT_WHITE = {SpecifiedColor={R=1,G=1,B=1,A=1}, ColorUseRule=0}

-- Fallback points
local FALLBACK_POINTS = {
  {name="aewol"},{name="1100"},{name="ansan"},{name="ara"},
  {name="coal"},{name="crude"},{name="dasa"},{name="dongbok"},
  {name="dragstrip"},{name="furniture"},{name="gosan"},
  {name="gwangjinstorage"},{name="harbor"},{name="iseungag"},
  {name="jail"},{name="joil"},{name="migeum"},{name="millgate"},
  {name="namdang"},{name="nobong"},{name="noksan"},{name="oak3"},
  {name="plastic"},{name="quarry"},{name="seoguipo"},
  {name="skydive"},{name="steel"},{name="sunflower"},
  {name="terra"},{name="tosan"},
}

-- ─── Helpers ────────────────────────────────────────────────────

local function GetHudWidget()
  local PC = GetMyPlayerController()
  if not PC or not PC:IsValid() then return nil end
  local HUD = PC:GetHUD()
  local hudClass = StaticFindObject("/Script/MotorTown.MotorTownInGameHUD")
  if not HUD or not HUD:IsValid() or not HUD:IsA(hudClass) then return nil end
  ---@cast HUD AMotorTownInGameHUD
  return (HUD.HUDWidget and HUD.HUDWidget:IsValid()) and HUD.HUDWidget or nil
end

local function FetchPoints()
  LogOutput("INFO", "[TeleportWidget] Fetching points...")

  -- Try ssl.https (luasec)
  local https = nil
  local okHttps, errHttps = pcall(function() https = require("ssl.https") end)
  if okHttps and https then
    LogOutput("DEBUG", "[TeleportWidget] Using ssl.https")
    local bodyParts = {}
    local ok, code = pcall(https.request, { url = API_URL, method = "GET", sink = ltn12.sink.table(bodyParts) })
    if ok and code == 200 then
      local body = table.concat(bodyParts)
      local data, parsed = pcall(json.parse, body)
      if data and type(parsed) == "table" and #parsed > 0 then
        local out = {}
        for _, item in ipairs(parsed) do
          local name = item.name or item.location_name
          if name then table.insert(out, {name=name}) end
        end
        LogOutput("INFO", "[TeleportWidget] ssl.https fetched %d points", #out)
        return out
      end
    else
      LogOutput("WARN", "[TeleportWidget] ssl.https failed: %s", tostring(code))
    end
  else
    LogOutput("DEBUG", "[TeleportWidget] ssl.https not available (%s)", tostring(errHttps))
  end

  -- Try socket.http
  local bodyParts = {}
  local ok, code = pcall(http.request, { url = API_URL, method = "GET", sink = ltn12.sink.table(bodyParts) })
  if ok and code == 200 then
    local body = table.concat(bodyParts)
    local data, parsed = pcall(json.parse, body)
    if data and type(parsed) == "table" and #parsed > 0 then
      local out = {}
      for _, item in ipairs(parsed) do
        local name = item.name or item.location_name
        if name then table.insert(out, {name=name}) end
      end
      LogOutput("INFO", "[TeleportWidget] socket.http fetched %d points", #out)
      return out
    end
  else
    LogOutput("WARN", "[TeleportWidget] socket.http failed: %s", tostring(code))
  end

  LogOutput("WARN", "[TeleportWidget] Using fallback (%d points)", #FALLBACK_POINTS)
  return FALLBACK_POINTS
end

-- ─── UI Update ──────────────────────────────────────────────────

local function UpdatePage()
  local totalPages = math.max(1, math.ceil(#points / ITEMS_PER_PAGE))
  if currentPage > totalPages then currentPage = totalPages end
  if currentPage < 1 then currentPage = 1 end

  -- Update title
  if pageLabel and pageLabel:IsValid() then
    pageLabel:SetText(FText(string.format("Teleport %d/%d", currentPage, totalPages)))
  end

  -- Update 8 buttons
  local startIdx = (currentPage - 1) * ITEMS_PER_PAGE + 1
  for i = 1, ITEMS_PER_PAGE do
    local btn = buttons[i]
    if not btn or not btn:IsValid() then goto continue end

    local point = points[startIdx + i - 1]
    if point then
      local txt = btn:GetContent()
      if txt and txt:IsValid() then
        txt:SetText(FText(point.name))
      end
      btn:SetVisibility(VIS_VISIBLE)
    else
      btn:SetVisibility(VIS_COLLAPSED)
    end
    ::continue::
  end
end

-- ─── Build ──────────────────────────────────────────────────────

function TeleportWidget.Build()
  if isBuilt then return true end
  LogOutput("DEBUG", "[TeleportWidget] ===== Build start =====")

  local hudWidget = GetHudWidget()
  if not hudWidget then
    LogOutput("ERROR", "[TeleportWidget] HUD not ready")
    return false
  end

  local rootCanvas = hudWidget.RootCanvasPanel
  if not rootCanvas or not rootCanvas:IsValid() then
    LogOutput("ERROR", "[TeleportWidget] RootCanvasPanel missing")
    return false
  end

  -- Fetch data
  points = FetchPoints()

  -- Find classes
  local BorderClass = StaticFindObject("/Script/UMG.Border")
  local VBoxClass = StaticFindObject("/Script/UMG.VerticalBox")
  local HBoxClass = StaticFindObject("/Script/UMG.HorizontalBox")
  local TextClass = StaticFindObject("/Script/UMG.TextBlock")
  local ButtonClass = StaticFindObject("/Script/UMG.Button")

  if not BorderClass or not VBoxClass or not HBoxClass or not TextClass or not ButtonClass then
    LogOutput("ERROR", "[TeleportWidget] One or more UMG classes not found")
    return false
  end

  -- Root border
  rootPanel = StaticConstructObject(BorderClass, hudWidget, FName("TeleportWidgetRoot"))
  if not rootPanel or not rootPanel:IsValid() then
    LogOutput("ERROR", "[TeleportWidget] Failed to create Border")
    return false
  end
  pcall(function()
    rootPanel:SetBrushColor(BG_COLOR)
    rootPanel:SetPadding({Left=12, Top=12, Right=12, Bottom=12})
  end)

  -- Main vertical layout
  local vbox = StaticConstructObject(VBoxClass, rootPanel, FName("TeleportVBox"))
  if not vbox or not vbox:IsValid() then
    LogOutput("ERROR", "[TeleportWidget] Failed to create VerticalBox")
    return false
  end

  -- Title row (horizontal)
  local titleRow = StaticConstructObject(HBoxClass, vbox, FName("TeleportTitleRow"))

  -- Title text
  local titleText = StaticConstructObject(TextClass, titleRow, FName("TeleportTitle"))
  if titleText and titleText:IsValid() then
    titleText:SetText(FText("Teleport"))
    titleText.Font = {Size = 16}
    titleText:SetColorAndOpacity(TEXT_WHITE)
  end
  local titleSlot = titleRow:AddChild(titleText)
  if titleSlot and titleSlot:IsValid() then
    titleSlot:SetPadding({Left=4, Top=4, Right=10, Bottom=4})
  end

  -- Page counter
  pageLabel = StaticConstructObject(TextClass, titleRow, FName("TeleportPageLabel"))
  if pageLabel and pageLabel:IsValid() then
    pageLabel:SetText(FText("1/1"))
    pageLabel.Font = {Size = 14}
    pageLabel:SetColorAndOpacity(TEXT_WHITE)
  end
  local pageSlot = titleRow:AddChild(pageLabel)
  if pageSlot and pageSlot:IsValid() then
    pageSlot:SetPadding({Left=4, Top=6, Right=10, Bottom=4})
  end

  -- [<] button
  navPrev = StaticConstructObject(ButtonClass, titleRow, FName("TeleportPrev"))
  if navPrev and navPrev:IsValid() then
    local prevText = StaticConstructObject(TextClass, navPrev, FName("TeleportPrevText"))
    if prevText and prevText:IsValid() then
      prevText:SetText(FText("<"))
      prevText.Font = {Size = 16}
      prevText:SetColorAndOpacity(TEXT_WHITE)
    end
    navPrev:SetContent(prevText)
    navPrev:SetBackgroundColor(NAV_BG)
  end
  local prevSlot = titleRow:AddChild(navPrev)
  if prevSlot and prevSlot:IsValid() then
    prevSlot:SetPadding({Left=4, Top=2, Right=4, Bottom=2})
  end

  -- [>] button
  navNext = StaticConstructObject(ButtonClass, titleRow, FName("TeleportNext"))
  if navNext and navNext:IsValid() then
    local nextText = StaticConstructObject(TextClass, navNext, FName("TeleportNextText"))
    if nextText and nextText:IsValid() then
      nextText:SetText(FText(">"))
      nextText.Font = {Size = 16}
      nextText:SetColorAndOpacity(TEXT_WHITE)
    end
    navNext:SetContent(nextText)
    navNext:SetBackgroundColor(NAV_BG)
  end
  local nextSlot = titleRow:AddChild(navNext)
  if nextSlot and nextSlot:IsValid() then
    nextSlot:SetPadding({Left=4, Top=2, Right=4, Bottom=2})
  end

  -- Add title row to main vbox
  local rowSlot = vbox:AddChild(titleRow)
  if rowSlot and rowSlot:IsValid() then
    rowSlot:SetPadding({Left=0, Top=0, Right=0, Bottom=8})
  end

  -- Create 8 item buttons
  local buttonsVBox = StaticConstructObject(VBoxClass, vbox, FName("TeleportButtonsVBox"))
  for i = 1, ITEMS_PER_PAGE do
    local btn = StaticConstructObject(ButtonClass, buttonsVBox, FName("TPBtn_" .. i))
    if btn and btn:IsValid() then
      local txt = StaticConstructObject(TextClass, btn, FName("TPBtnTxt_" .. i))
      if txt and txt:IsValid() then
        txt:SetText(FText("---"))
        txt.Font = {Size = 13}
        txt:SetColorAndOpacity(TEXT_WHITE)
      end
      btn:SetContent(txt)
      btn:SetBackgroundColor(BTN_BG)
      btn:SetVisibility(VIS_COLLAPSED) -- hidden until page update
    end
    table.insert(buttons, btn)
    local bslot = buttonsVBox:AddChild(btn)
    if bslot and bslot:IsValid() then
      bslot:SetPadding({Left=2, Top=3, Right=2, Bottom=3})
    end
  end

  -- Add buttons container to main vbox
  vbox:AddChild(buttonsVBox)

  -- Set border content
  pcall(function() rootPanel:SetContent(vbox) end)

  -- Add to HUD canvas
  local canvasSlot = rootCanvas:AddChildToCanvas(rootPanel)
  if not canvasSlot or not canvasSlot:IsValid() then
    LogOutput("ERROR", "[TeleportWidget] Failed to attach to HUD")
    return false
  end
  pcall(function()
    canvasSlot:SetAnchors({Minimum={X=0.5,Y=1.0}, Maximum={X=0.5,Y=1.0}})
    canvasSlot:SetAlignment({X=0.5, Y=1.0})
    canvasSlot:SetPosition({X=0, Y=-20})
    canvasSlot:SetSize({X=WIDGET_W, Y=WIDGET_H})
    canvasSlot:SetZOrder(100)
  end)

  rootPanel:SetVisibility(VIS_COLLAPSED)

  -- Initial page render
  UpdatePage()

  -- Poll for button presses in game thread (no delegates)
  LogOutput("DEBUG", "[TeleportWidget] Starting button poll loop")
  LoopInGameThreadWithDelay(0.05, function()
    if not isVisible then return false end -- keep looping but do nothing
    if not rootPanel or not rootPanel:IsValid() then return true end -- stop

    -- Check nav buttons
    if navPrev and navPrev:IsValid() and navPrev:IsPressed() then
      LogOutput("DEBUG", "[TeleportWidget] [<] pressed")
      currentPage = currentPage - 1
      UpdatePage()
      -- debounce: wait for release
      while navPrev:IsPressed() do end
    end

    if navNext and navNext:IsValid() and navNext:IsPressed() then
      LogOutput("DEBUG", "[TeleportWidget] [>] pressed")
      currentPage = currentPage + 1
      UpdatePage()
      while navNext:IsPressed() do end
    end

    -- Check item buttons
    local startIdx = (currentPage - 1) * ITEMS_PER_PAGE + 1
    for i = 1, ITEMS_PER_PAGE do
      local btn = buttons[i]
      if btn and btn:IsValid() and btn:IsPressed() then
        local point = points[startIdx + i - 1]
        if point then
          LogOutput("INFO", "[TeleportWidget] Teleport to: %s", point.name)
          local PC = GetMyPlayerController()
          if PC and PC:IsValid() then
            PC:ServerSendChat("/tp " .. point.name, 0)
          end
          -- debounce
          while btn:IsPressed() do end
        end
      end
    end

    return false -- keep looping
  end)

  isBuilt = true
  LogOutput("INFO", "[TeleportWidget] ===== Build complete =====")
  return true
end

-- ─── Toggle ─────────────────────────────────────────────────────

function TeleportWidget.Toggle()
  LogOutput("DEBUG", "[TeleportWidget] Toggle() visible=%s", tostring(isVisible))
  if not isBuilt then
    TeleportWidget.Build()
  end
  if not isBuilt then
    LogOutput("ERROR", "[TeleportWidget] Build failed, cannot toggle")
    return
  end

  if isVisible then
    rootPanel:SetVisibility(VIS_COLLAPSED)
    isVisible = false
    LogOutput("INFO", "[TeleportWidget] Hidden")
  else
    rootPanel:SetVisibility(VIS_VISIBLE)
    isVisible = true
    LogOutput("INFO", "[TeleportWidget] Shown")
  end
end

-- ─── Keybind ────────────────────────────────────────────────────

RegisterKeyBind(Key.TAB, {}, function()
  TeleportWidget.Toggle()
end)

return TeleportWidget
