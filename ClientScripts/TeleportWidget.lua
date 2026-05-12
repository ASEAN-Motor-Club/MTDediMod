--- TeleportWidget — paginated teleport list overlay
--- Shows on TAB, polls button presses, sends /tp via chat

local UEHelpers = require("UEHelpers")
local json = require("JsonParser")

-- ── Config ────────────────────────────────────────────────────────────────
local ITEMS_PER_PAGE = 8
local API_URL = "https://server.aseanmotorclub.com/api/v1/teleports/"
local POLL_INTERVAL_MS = 100
local DEBOUNCE_MS = 150

-- ── State ─────────────────────────────────────────────────────────────────
local sizeBox = nil             ---@type USizeBox
local widgetRoot = nil          ---@type UBorder
local titleText = nil           ---@type UTextBlock
local itemButtons = {}          ---@type UButton[]
local navPrevBtn = nil          ---@type UButton
local navNextBtn = nil          ---@type UButton
local isVisible = false
local currentPage = 1
local teleportPoints = {}       ---@type {name: string, x: number, y: number, z: number}[]
local totalPages = 1
local lastPressed = {}          ---@type table<UButton, number>
local pollHandle = nil
local fetchAttempted = false

-- ── Helpers ───────────────────────────────────────────────────────────────
local function FLinearColor(R, G, B, A) return {R=R, G=G, B=B, A=A} end
local function FSlateColor(R, G, B, A)
    return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0}
end

local function GetHUD()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return nil end
    local hud = PC.MyHUD
    if not hud or not hud:IsValid() then return nil end
    return hud
end

local function GetHudWidget()
    local PC = GetMyPlayerController()
    if not PC or not PC:IsValid() then return nil end
    local HUD = PC:GetHUD()
    local hudClass = StaticFindObject("/Script/MotorTown.MotorTownInGameHUD")
    if not HUD or not HUD:IsValid() or not hudClass:IsValid() or not HUD:IsA(hudClass) then
        return nil
    end
    ---@cast HUD AMotorTownInGameHUD
    local widget = HUD.HUDWidget
    if widget and widget:IsValid() then
        return widget
    end
    return nil
end

-- ── Fetch teleport points ─────────────────────────────────────────────────
local function LoadHardcodedPoints()
    local tm = require("TeleportManager")
    -- TeleportManager doesn't expose defaultPoints directly, but we can reconstruct
    -- from its GetPointNames + FindTeleportPoint or use the same list
    local names = tm.GetPointNames and tm.GetPointNames() or {}
    local points = {}
    for _, name in ipairs(names) do
        table.insert(points, { name = name })
    end
    if #points == 0 then
        -- Fallback if TeleportManager API unavailable
        local hardcoded = {
            "1100", "aewol", "ansan", "ara", "coal", "crude", "dasa", "dongbok",
            "dragstrip", "furniture", "gosan", "gwangjinstorage", "harbor", "iseungag",
            "jail", "joil", "migeum", "millgate", "namdang", "nobong", "noksan",
            "oak3", "plastic", "quarry", "seoguipo", "skydive", "steel", "sunflower",
            "terra", "tosan"
        }
        for _, name in ipairs(hardcoded) do
            table.insert(points, { name = name })
        end
    end
    return points
end

local function FetchApiPoints()
    if fetchAttempted then return end
    fetchAttempted = true

    local fetch = require("fetch.init")

    local data, err = fetch.get(API_URL)
    if data then
        LogOutput("INFO", "[TeleportWidget] API response: %s", json.stringify(data))
        if type(data) == "table" then
            local points = {}
            for _, item in ipairs(data) do
                if item.name then
                    table.insert(points, { name = item.name, x = item.x, y = item.y, z = item.z })
                end
            end
            if #points > 0 then
                teleportPoints = points
                LogOutput("INFO", "[TeleportWidget] Loaded %d points from API via fetch", #points)
                return
            end
        end
    end

    LogOutput("WARN", "[TeleportWidget] API fetch failed (%s), using hardcoded points", tostring(err))
    teleportPoints = LoadHardcodedPoints()
end

-- ── Widget construction ───────────────────────────────────────────────────
local function BuildWidget()
    if widgetRoot and widgetRoot:IsValid() then return end

    local hudWidget = GetHudWidget()
    if not hudWidget then
        LogOutput("WARN", "[TeleportWidget] HUD widget not available")
        return
    end

    local rootCanvas = hudWidget.RootCanvasPanel
    if not rootCanvas or not rootCanvas:IsValid() then
        LogOutput("WARN", "[TeleportWidget] RootCanvasPanel not available")
        return
    end

    -- Size box for width control
    sizeBox = StaticConstructObject(
        StaticFindObject("/Script/UMG.SizeBox"),
        rootCanvas, FName("TeleportSizeBox"))
    if not sizeBox or not sizeBox:IsValid() then return end
    sizeBox:SetWidthOverride(360)

    -- Root border
    widgetRoot = StaticConstructObject(
        StaticFindObject("/Script/UMG.Border"),
        sizeBox, FName("TeleportWidgetRoot"))
    if not widgetRoot or not widgetRoot:IsValid() then return end

    widgetRoot:SetBrushColor(FLinearColor(0.06, 0.06, 0.1, 0.92))
    widgetRoot:SetPadding({Left=20, Top=12, Right=20, Bottom=12})
    sizeBox:SetContent(widgetRoot)

    -- Vertical layout
    local vbox = StaticConstructObject(
        StaticFindObject("/Script/UMG.VerticalBox"),
        widgetRoot, FName("TeleportVBox"))
    widgetRoot:SetContent(vbox)

    -- Title
    titleText = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        vbox, FName("TeleportTitle"))
    titleText.Font.Size = 16
    titleText:SetText(FText("Teleport"))
    titleText:SetColorAndOpacity(FSlateColor(0.0, 0.8, 1.0, 1))
    titleText:SetShadowOffset({X=1, Y=1})
    titleText:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.6))
    local titleSlot = vbox:AddChildToVerticalBox(titleText)
    if titleSlot and titleSlot:IsValid() then
        titleSlot:SetPadding({Bottom=8})
    end

    -- Item buttons (8 per page)
    itemButtons = {}
    for i = 1, ITEMS_PER_PAGE do
        local btn = StaticConstructObject(
            StaticFindObject("/Script/UMG.Button"),
            vbox, FName("TeleportBtn" .. i))
        local btnText = StaticConstructObject(
            StaticFindObject("/Script/UMG.TextBlock"),
            btn, FName("TeleportBtnText" .. i))
        btnText.Font.Size = 13
        btnText:SetText(FText(""))
        btnText:SetColorAndOpacity(FSlateColor(0.9, 0.9, 0.9, 1))
        btn:SetContent(btnText)
        btn:SetBackgroundColor(FLinearColor(0.12, 0.14, 0.18, 0.7))

        local btnSlot = vbox:AddChildToVerticalBox(btn)
        if btnSlot and btnSlot:IsValid() then
            btnSlot:SetPadding({Top=2, Bottom=2})
        end

        itemButtons[i] = { button = btn, text = btnText }
    end

    -- Nav row
    local hbox = StaticConstructObject(
        StaticFindObject("/Script/UMG.HorizontalBox"),
        vbox, FName("TeleportNavHBox"))
    local navSlot = vbox:AddChildToVerticalBox(hbox)
    if navSlot and navSlot:IsValid() then
        navSlot:SetPadding({Top=8})
    end

    -- Left spacer to center nav buttons
    local spacerLeft = StaticConstructObject(
        StaticFindObject("/Script/UMG.Spacer"),
        hbox, FName("TeleportSpacerLeft"))
    local spacerLeftSlot = hbox:AddChildToHorizontalBox(spacerLeft)
    if spacerLeftSlot and spacerLeftSlot:IsValid() then
        spacerLeftSlot:SetSize({SizeRule = 1, Value = 1.0}) -- Fill
    end

    -- Prev button
    navPrevBtn = StaticConstructObject(
        StaticFindObject("/Script/UMG.Button"),
        hbox, FName("TeleportPrevBtn"))
    local prevText = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        navPrevBtn, FName("TeleportPrevText"))
    prevText.Font.Size = 14
    prevText:SetText(FText("<"))
    prevText:SetColorAndOpacity(FSlateColor(0.0, 0.7, 1.0, 1))
    navPrevBtn:SetContent(prevText)
    navPrevBtn:SetBackgroundColor(FLinearColor(0.1, 0.12, 0.16, 0.8))
    local prevSlot = hbox:AddChildToHorizontalBox(navPrevBtn)
    if prevSlot and prevSlot:IsValid() then
        prevSlot:SetPadding({Right=8})
    end

    -- Next button
    navNextBtn = StaticConstructObject(
        StaticFindObject("/Script/UMG.Button"),
        hbox, FName("TeleportNextBtn"))
    local nextText = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        navNextBtn, FName("TeleportNextText"))
    nextText.Font.Size = 14
    nextText:SetText(FText(">"))
    nextText:SetColorAndOpacity(FSlateColor(0.0, 0.7, 1.0, 1))
    navNextBtn:SetContent(nextText)
    navNextBtn:SetBackgroundColor(FLinearColor(0.1, 0.12, 0.16, 0.8))
    local nextSlot = hbox:AddChildToHorizontalBox(navNextBtn)
    if nextSlot and nextSlot:IsValid() then
        nextSlot:SetPadding({Left=8})
    end

    -- Right spacer to center nav buttons
    local spacerRight = StaticConstructObject(
        StaticFindObject("/Script/UMG.Spacer"),
        hbox, FName("TeleportSpacerRight"))
    local spacerRightSlot = hbox:AddChildToHorizontalBox(spacerRight)
    if spacerRightSlot and spacerRightSlot:IsValid() then
        spacerRightSlot:SetSize({SizeRule = 1, Value = 1.0}) -- Fill
    end

    -- Position on HUD (centered horizontally, lower third vertically)
    local canvasSlot = rootCanvas:AddChildToCanvas(sizeBox)
    if canvasSlot and canvasSlot:IsValid() then
        canvasSlot:SetAnchors({
            Minimum = {X=0.5, Y=0.75},
            Maximum = {X=0.5, Y=0.75}
        })
        canvasSlot:SetAlignment({X=0.5, Y=1})
        canvasSlot:SetAutoSize(true)
    end

    sizeBox:SetVisibility(1) -- Collapsed
    LogOutput("INFO", "[TeleportWidget] Widget built")
end

-- ── Update display ────────────────────────────────────────────────────────
local function UpdateDisplay()
    if not widgetRoot or not widgetRoot:IsValid() then return end

    totalPages = math.max(1, math.ceil(#teleportPoints / ITEMS_PER_PAGE))
    if currentPage > totalPages then currentPage = totalPages end
    if currentPage < 1 then currentPage = 1 end

    titleText:SetText(FText(string.format("Teleport  %d/%d", currentPage, totalPages)))

    local startIdx = (currentPage - 1) * ITEMS_PER_PAGE + 1
    for i = 1, ITEMS_PER_PAGE do
        local entry = itemButtons[i]
        local idx = startIdx + i - 1
        if idx <= #teleportPoints then
            entry.text:SetText(FText(teleportPoints[idx].name))
            entry.text:SetColorAndOpacity(FSlateColor(0.9, 0.9, 0.9, 1))
            entry.button:SetVisibility(0) -- Visible
        else
            entry.text:SetText(FText(""))
            entry.button:SetVisibility(1) -- Collapsed
        end
    end
end

-- ── Teleport action ───────────────────────────────────────────────────────
local function DoTeleportByName(name)
    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC or not PC:IsValid() then
            LogOutput("WARN", "[TeleportWidget] PlayerController not valid")
            return
        end
        PC:ServerSendChat("/tp " .. name, 0)
        LogOutput("INFO", "[TeleportWidget] Sent /tp %s", name)
    end)
end

-- ── Polling loop ──────────────────────────────────────────────────────────
local function StartPolling()
    if pollHandle then return end

    pollHandle = LoopInGameThreadWithDelay(POLL_INTERVAL_MS, function()
        if not isVisible then return end
        if not widgetRoot or not widgetRoot:IsValid() then return end

        local now = os.clock() * 1000

        -- Check item buttons
        local startIdx = (currentPage - 1) * ITEMS_PER_PAGE + 1
        for i = 1, ITEMS_PER_PAGE do
            local entry = itemButtons[i]
            local btn = entry.button
            if btn and btn:IsValid() and btn:GetVisibility() == 0 then
                if btn:IsPressed() then
                    local last = lastPressed[btn] or 0
                    if now - last > DEBOUNCE_MS then
                        lastPressed[btn] = now
                        local idx = startIdx + i - 1
                        if idx <= #teleportPoints then
                            DoTeleportByName(teleportPoints[idx].name)
                        end
                    end
                end
            end
        end

        -- Check nav buttons
        if navPrevBtn and navPrevBtn:IsValid() then
            if navPrevBtn:IsPressed() then
                local last = lastPressed[navPrevBtn] or 0
                if now - last > DEBOUNCE_MS then
                    lastPressed[navPrevBtn] = now
                    if currentPage > 1 then
                        currentPage = currentPage - 1
                        UpdateDisplay()
                    end
                end
            end
        end

        if navNextBtn and navNextBtn:IsValid() then
            if navNextBtn:IsPressed() then
                local last = lastPressed[navNextBtn] or 0
                if now - last > DEBOUNCE_MS then
                    lastPressed[navNextBtn] = now
                    if currentPage < totalPages then
                        currentPage = currentPage + 1
                        UpdateDisplay()
                    end
                end
            end
        end
    end)

    LogOutput("INFO", "[TeleportWidget] Polling loop started")
end

local function StopPolling()
    CancelDelayedAction(pollHandle)
    pollHandle = nil
    LogOutput("INFO", "[TeleportWidget] Polling loop stopped")
end

-- ── Show / Hide ───────────────────────────────────────────────────────────
local function Show()
    if not sizeBox or not sizeBox:IsValid() then
        BuildWidget()
    end
    if not sizeBox or not sizeBox:IsValid() then return end

    if not fetchAttempted then
        FetchApiPoints()
    end

    UpdateDisplay()
    sizeBox:SetVisibility(0) -- Visible
    isVisible = true
    StartPolling()
    LogOutput("DEBUG", "[TeleportWidget] Shown")
end

local function Hide()
    if sizeBox and sizeBox:IsValid() then
        sizeBox:SetVisibility(1) -- Collapsed
    end
    isVisible = false
    StopPolling()
    LogOutput("DEBUG", "[TeleportWidget] Hidden")
end

local function Toggle()
    if isVisible then Hide() else Show() end
end

-- ── Keybind ───────────────────────────────────────────────────────────────
RegisterKeyBind(Key.TAB, {}, function()
    ExecuteInGameThread(function()
        Show()
    end)
end)

RegisterKeyBind(Key.ESCAPE, {}, function()
    ExecuteInGameThread(function()
        if isVisible then Hide() end
    end)
end)

-- ── Init ──────────────────────────────────────────────────────────────────
ExecuteInGameThread(function()
    BuildWidget()
    FetchApiPoints()
end)

return {
    Show = Show,
    Hide = Hide,
    Toggle = Toggle,
}
