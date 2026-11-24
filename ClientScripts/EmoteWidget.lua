--- EmoteWidget — emote command menu attached to the side of the teleport menu
--- Shows/hides alongside teleport widget (TAB open, ESC close)

-- ── Config ────────────────────────────────────────────────────────────────
local DEBOUNCE_MS = 150

local EMOTES = {
    { name = "Wave",        cmd = "/Wave" },
    { name = "Wave Hands",  cmd = "/WaveHands" },
    { name = "Chicken Dance", cmd = "/ChickenDance" },
    { name = "Horse Dance",   cmd = "/HorseDance" },
    { name = "Pointing",    cmd = "/Pointing" },
}

-- ── State ─────────────────────────────────────────────────────────────────
local sizeBox = nil         ---@type USizeBox
local widgetRoot = nil      ---@type UBorder
local itemButtons = {}      ---@type {button: UButton, text: UTextBlock}[]
local isVisible = false
local clickTargets = {}     ---@type table<UMTButtonWidget, function>
local buttonTargetClass = nil
local lastClickTime = 0
local DoEmote

-- ── Helpers ───────────────────────────────────────────────────────────────
local function FLinearColor(R, G, B, A) return {R=R, G=G, B=B, A=A} end
local function FSlateColor(R, G, B, A)
    return {SpecifiedColor=FLinearColor(R,G,B,A), ColorUseRule=0}
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

-- UButton.OnClicked is bound to a UObject target; OnButtonClicked dispatches
-- the action. No button state is ever polled.
local function BindClick(btn, outer, name, action)
    if not btn or not btn:IsValid() then return end
    if not buttonTargetClass then
        buttonTargetClass = StaticFindObject("/Script/MotorTown.MTButtonWidget")
    end
    if not buttonTargetClass or not buttonTargetClass:IsValid() then return end
    local target = StaticConstructObject(buttonTargetClass, outer, FName(name))
    if not target or not target:IsValid() then return end
    local ok, err = pcall(function() btn.OnClicked:Add(target, "OnButtonClicked") end)
    if not ok then
        LogOutput("WARN", "[EmoteWidget] OnClicked bind failed for %s: %s", name, tostring(err))
        return
    end
    clickTargets[target] = action
end

-- ── Widget construction ───────────────────────────────────────────────────
local function BuildWidget()
    clickTargets = {}
    if widgetRoot and widgetRoot:IsValid() then return end

    local hudWidget = GetHudWidget()
    if not hudWidget then
        LogOutput("WARN", "[EmoteWidget] HUD widget not available")
        return
    end

    local rootCanvas = hudWidget.RootCanvasPanel
    if not rootCanvas or not rootCanvas:IsValid() then
        LogOutput("WARN", "[EmoteWidget] RootCanvasPanel not available")
        return
    end

    -- Size box for width control
    sizeBox = StaticConstructObject(
        StaticFindObject("/Script/UMG.SizeBox"),
        rootCanvas, FName("EmoteSizeBox"))
    if not sizeBox or not sizeBox:IsValid() then return end
    sizeBox:SetWidthOverride(200)

    -- Root border
    widgetRoot = StaticConstructObject(
        StaticFindObject("/Script/UMG.Border"),
        sizeBox, FName("EmoteWidgetRoot"))
    if not widgetRoot or not widgetRoot:IsValid() then return end

    widgetRoot:SetBrushColor(FLinearColor(0.06, 0.06, 0.1, 0.92))
    widgetRoot:SetPadding({Left=16, Top=12, Right=16, Bottom=12})
    sizeBox:SetContent(widgetRoot)

    -- Vertical layout
    local vbox = StaticConstructObject(
        StaticFindObject("/Script/UMG.VerticalBox"),
        widgetRoot, FName("EmoteVBox"))
    widgetRoot:SetContent(vbox)

    -- Title
    local titleText = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        vbox, FName("EmoteTitle"))
    titleText.Font.Size = 16
    titleText:SetText(FText("Emote"))
    titleText:SetColorAndOpacity(FSlateColor(1.0, 0.6, 0.2, 1))
    titleText:SetShadowOffset({X=1, Y=1})
    titleText:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.6))
    local titleSlot = vbox:AddChildToVerticalBox(titleText)
    if titleSlot and titleSlot:IsValid() then
        titleSlot:SetPadding({Bottom=8})
    end

    -- Emote buttons
    itemButtons = {}
    for i, emote in ipairs(EMOTES) do
        local btn = StaticConstructObject(
            StaticFindObject("/Script/UMG.Button"),
            vbox, FName("EmoteBtn" .. i))
        local btnText = StaticConstructObject(
            StaticFindObject("/Script/UMG.TextBlock"),
            btn, FName("EmoteBtnText" .. i))
        btnText.Font.Size = 13
        btnText:SetText(FText(emote.name))
        btnText:SetColorAndOpacity(FSlateColor(0.9, 0.9, 0.9, 1))
        btn:SetContent(btnText)
        btn:SetBackgroundColor(FLinearColor(0.12, 0.14, 0.18, 0.7))

        local btnSlot = vbox:AddChildToVerticalBox(btn)
        if btnSlot and btnSlot:IsValid() then
            btnSlot:SetPadding({Top=2, Bottom=2})
        end

        itemButtons[i] = { button = btn, text = btnText, cmd = emote.cmd }
        BindClick(btn, vbox, "EmoteClickTarget" .. i, function()
            DoEmote(emote.cmd)
        end)
    end

    -- Position on HUD (to the right of teleport widget)
    local canvasSlot = rootCanvas:AddChildToCanvas(sizeBox)
    if canvasSlot and canvasSlot:IsValid() then
        canvasSlot:SetAnchors({
            Minimum = {X=0.65, Y=0.75},
            Maximum = {X=0.65, Y=0.75}
        })
        canvasSlot:SetAlignment({X=0.5, Y=1})
        canvasSlot:SetAutoSize(true)
    end

    sizeBox:SetVisibility(1) -- Collapsed
    LogOutput("INFO", "[EmoteWidget] Widget built")
end

-- ── Emote action ──────────────────────────────────────────────────────────
DoEmote = function(cmd)
    ExecuteInGameThread(function()
        local PC = GetMyPlayerController()
        if not PC or not PC:IsValid() then
            LogOutput("WARN", "[EmoteWidget] PlayerController not valid")
            return
        end
        PC:ServerSendChat(cmd, 0)
        LogOutput("INFO", "[EmoteWidget] Sent %s", cmd)
    end)
end

-- ── Click dispatch (event-driven; no button polling) ─────────────────────
RegisterHook("/Script/MotorTown.MTButtonWidget:OnButtonClicked", function(Context)
    local target = Context:get()
    local action = target and clickTargets[target]
    if not action then return end
    if not isVisible then return end
    local now = os.clock() * 1000
    if now - lastClickTime < DEBOUNCE_MS then return end
    lastClickTime = now
    action()
end)

-- ── Show / Hide ───────────────────────────────────────────────────────────
local function Show()
    if not sizeBox or not sizeBox:IsValid() then
        BuildWidget()
    end
    if not sizeBox or not sizeBox:IsValid() then return end

    sizeBox:SetVisibility(0) -- Visible
    isVisible = true
    LogOutput("DEBUG", "[EmoteWidget] Shown")
end

local function Hide()
    if sizeBox and sizeBox:IsValid() then
        sizeBox:SetVisibility(1) -- Collapsed
    end
    isVisible = false
    LogOutput("DEBUG", "[EmoteWidget] Hidden")
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
end)

return {
    Show = Show,
    Hide = Hide,
    Toggle = Toggle,
}
