--- ModManager — in-game mod status panel
---
--- Primary path (pak loaded):
---   Ctrl+M → HUD:PushFullScreenMenuWidget(WBP_ModManager_C, false)
---   Rows are TextBlock children added via Lua into widget.ModListScrollBox
---   ESC or Ctrl+M again → HUD:PopFullScreenMenuWidget to dismiss
---
--- Fallback (pak not present):
---   Pure Lua canvas overlay (Canvas → Border → TextBlock), same as before.

local UEHelpers = require("UEHelpers")

local VIS_SELF_HIT_INVISIBLE = 4
local VIS_COLLAPSED          = 1

local STATUS_ICON = { ok = "✓", outdated = "⚠", missing = "✗" }

-- Blueprint pak asset class paths (UE internal paths inside the pak)
local BP_MANAGER_PATH = "/Game/Mods/ModManager/WBP_ModManager.WBP_ModManager_C"
local BP_ENTRY_PATH   = "/Game/Mods/ModManager/WBP_ModManagerEntry.WBP_ModManagerEntry_C"

local bpManagerClass = nil   -- UClass for WBP_ModManager_C (from pak)
local bpEntryClass   = nil   -- UClass for WBP_ModManagerEntry_C (from pak, optional)
local activeBpWidget = nil   -- currently pushed WBP_ModManager instance
local rowCounter     = 0     -- unique FName counter for dynamic rows

-- ── Fallback Lua-only widget state ────────────────────────────────────────
local hudWidget  = nil
local rootCanvas = nil
local textBlock  = nil
local luaVisible = false

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

-- ── Asset Registry helper (same approach BPModLoaderMod uses for ModActor) ─
local function GetAssetRegistry()
    local helpers = StaticFindObject("/Script/AssetRegistry.Default__AssetRegistryHelpers")
    if helpers and helpers:IsValid() then
        local reg = helpers:GetAssetRegistry()
        if reg and reg:IsValid() then return helpers, reg end
    end
    -- Fallback
    local reg = StaticFindObject("/Script/AssetRegistry.Default__AssetRegistryImpl")
    if reg and reg:IsValid() then return nil, reg end
    return nil, nil
end

local function LoadBpClass(packagePath, assetName)
    -- Method 1: AssetRegistry with _C name (works for actor BPs)
    local helpers, _ = GetAssetRegistry()
    if helpers then
        local assetData = (UnrealVersion.IsBelow(5, 1))
            and { ObjectPath = UEHelpers.FindOrAddFName(packagePath .. "." .. assetName) }
            or  { PackageName = UEHelpers.FindOrAddFName(packagePath),
                  AssetName   = UEHelpers.FindOrAddFName(assetName) }
        local cls = helpers:GetAsset(assetData)
        if cls and cls:IsValid() then return cls end

        -- Method 1b: try bare name (Widget BPs registered without _C suffix)
        local bareName = assetName:gsub("_C$", "")
        if bareName ~= assetName then
            local assetData2 = { PackageName = UEHelpers.FindOrAddFName(packagePath),
                                  AssetName   = UEHelpers.FindOrAddFName(bareName) }
            local cls2 = helpers:GetAsset(assetData2)
            if cls2 and cls2:IsValid() then return cls2 end
        end
    end

    -- Method 2: LoadAsset + StaticFindObject (works once pak is mounted)
    LoadAsset(packagePath)
    local cls = StaticFindObject(packagePath .. "." .. assetName)
    return (cls and cls:IsValid()) and cls or nil
end


-- ── Probe pak widget classes ──────────────────────────────────────────────
local function ProbePakWidgets()
    bpManagerClass = LoadBpClass("/Game/Mods/ModManager/WBP_ModManager", "WBP_ModManager_C")
    bpEntryClass   = LoadBpClass("/Game/Mods/ModManager/WBP_ModManagerEntry", "WBP_ModManagerEntry_C")

    if bpManagerClass then
        LogOutput("INFO", "[ModManager] WBP_ModManager_C loaded via AssetRegistry ✓")
    else
        LogOutput("WARN", "[ModManager] WBP_ModManager_C not found — falling back to Lua overlay")
    end

    if bpEntryClass then
        LogOutput("INFO", "[ModManager] WBP_ModManagerEntry_C loaded ✓")
    else
        LogOutput("INFO", "[ModManager] WBP_ModManagerEntry_C not loaded (not needed for Lua rows)")
    end
end

-- ── Fallback: pure-Lua canvas widget ─────────────────────────────────────
local function BuildFallbackWidget()
    if hudWidget and hudWidget:IsValid() then return end
    local gi = UEHelpers.GetGameInstance()
    if not gi or not gi:IsValid() then
        LogOutput("WARN", "[ModManager] GameInstance not valid — cannot build fallback")
        return
    end

    hudWidget = StaticConstructObject(
        StaticFindObject("/Script/UMG.UserWidget"), gi, FName("ModManagerHUD"))
    hudWidget.WidgetTree = StaticConstructObject(
        StaticFindObject("/Script/UMG.WidgetTree"), hudWidget, FName("ModManagerTree"))

    rootCanvas = StaticConstructObject(
        StaticFindObject("/Script/UMG.CanvasPanel"),
        hudWidget.WidgetTree, FName("ModManagerCanvas"))
    hudWidget.WidgetTree.RootWidget = rootCanvas

    local border = StaticConstructObject(
        StaticFindObject("/Script/UMG.Border"),
        rootCanvas, FName("ModManagerBg"))
    border:SetBrushColor(FLinearColor(0.04, 0.04, 0.08, 0.88))
    border:SetPadding({Left=16, Top=12, Right=24, Bottom=14})

    textBlock = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        border, FName("ModManagerText"))
    textBlock.Font.Size = 12
    textBlock:SetText(FText("◈  MOD MANAGER"))
    textBlock:SetColorAndOpacity(FSlateColor(0.88, 0.94, 1.0, 1))
    textBlock:SetShadowOffset({X=1, Y=1})
    textBlock:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.55))
    border:SetContent(textBlock)

    local slot = rootCanvas:AddChildToCanvas(border)
    slot:SetAutoSize(true)
    slot:SetAnchors({Minimum={X=1.0, Y=0.0}, Maximum={X=1.0, Y=0.0}})
    slot:SetAlignment({X=1.0, Y=0.0})
    slot:SetPosition({X=-20, Y=80})

    border.Visibility    = VIS_SELF_HIT_INVISIBLE
    textBlock.Visibility = VIS_SELF_HIT_INVISIBLE
    rootCanvas.Visibility = VIS_COLLAPSED
    hudWidget:AddToViewport(50)
    LogOutput("INFO", "[ModManager] Fallback Lua widget built")
end

local function BuildFallbackText(entries)
    local lines = { "◈  MOD MANAGER  (fallback)", "─────────────────────────────────" }
    for _, e in ipairs(entries or {}) do
        local icon = STATUS_ICON[e.status] or "?"
        local ver  = e.version and ("  " .. e.version) or ""
        table.insert(lines, string.format("%s  %-28s%s", icon, e.name or "?", ver))
    end
    if not entries or #entries == 0 then
        table.insert(lines, "  (no mods)")
    end
    return table.concat(lines, "\n")
end

local function ShowFallback(entries)
    if not hudWidget or not hudWidget:IsValid() then BuildFallbackWidget() end
    if textBlock and textBlock:IsValid() then
        textBlock:SetText(FText(BuildFallbackText(entries)))
    end
    rootCanvas.Visibility = VIS_SELF_HIT_INVISIBLE
    luaVisible = true
    LogOutput("INFO", "[ModManager] Fallback shown")
end

local function HideFallback()
    if not hudWidget or not hudWidget:IsValid() then return end
    rootCanvas.Visibility = VIS_COLLAPSED
    luaVisible = false
end

-- ── BP widget: add a single text row to the ScrollBox ────────────────────
local function AddRow(scrollBox, rowText)
    rowCounter = rowCounter + 1
    local tb = StaticConstructObject(
        StaticFindObject("/Script/UMG.TextBlock"),
        scrollBox, FName("ModRow" .. rowCounter))
    if not tb or not tb:IsValid() then return end
    tb.Font.Size = 13
    tb:SetText(FText(rowText))
    tb:SetColorAndOpacity(FSlateColor(0.88, 0.94, 1.0, 1))
    tb:SetShadowOffset({X=1, Y=1})
    tb:SetShadowColorAndOpacity(FLinearColor(0, 0, 0, 0.55))
    local slot = scrollBox:AddChild(tb)
    if slot and slot:IsValid() then
        slot:SetPadding({Left=6, Top=3, Right=6, Bottom=3})
    end
end

-- ── BP widget: push onto native menu stack and populate ───────────────────
local function ShowBpWidget(entries)
    if activeBpWidget and activeBpWidget:IsValid() then
        LogOutput("INFO", "[ModManager] Already open")
        return
    end
    local hud = GetHUD()
    if not hud then
        LogOutput("WARN", "[ModManager] HUD not valid")
        return
    end

    ---@cast hud AMTHUD
    local widget = hud:PushFullScreenMenuWidget(bpManagerClass, false)
    if not widget or not widget:IsValid() then
        LogOutput("WARN", "[ModManager] PushFullScreenMenuWidget failed — check Canvas Visibility in UE5")
        return
    end
    activeBpWidget = widget
    rowCounter = 0

    -- Populate the scroll box (requires ModListScrollBox marked as Is Variable in UE5)
    local scrollBox = widget.ModListScrollBox
    if not scrollBox or not scrollBox:IsValid() then
        LogOutput("WARN", "[ModManager] ModListScrollBox not accessible — mark as Is Variable in Widget BP")
        -- Widget still shows its Blueprint shell (title etc.) even without rows
        return
    end

    scrollBox:ClearChildren()

    if not entries or #entries == 0 then
        AddRow(scrollBox, "  (no mods registered)")
    else
        for _, e in ipairs(entries) do
            local icon = STATUS_ICON[e.status] or "?"
            local ver  = e.version and ("  " .. e.version) or ""
            AddRow(scrollBox, string.format("%s  %-30s%s", icon, e.name or "?", ver))
        end
    end

    LogOutput("INFO", "[ModManager] BP widget pushed (%d entries)", entries and #entries or 0)
end

-- ── BP widget: pop from native menu stack ────────────────────────────────
local function HideBpWidget()
    if not activeBpWidget or not activeBpWidget:IsValid() then return end
    local hud = GetHUD()
    if hud then
        ---@cast hud AMTHUD
        hud:PopFullScreenMenuWidget(activeBpWidget)
    end
    activeBpWidget = nil
    rowCounter = 0
    LogOutput("INFO", "[ModManager] BP widget popped")
end

-- ── Public toggle ─────────────────────────────────────────────────────────
local function Toggle(entries)
    if bpManagerClass then
        -- Primary: native menu stack
        if activeBpWidget and activeBpWidget:IsValid() then
            HideBpWidget()
        else
            ShowBpWidget(entries)
        end
    else
        -- Fallback: Lua overlay
        if luaVisible then HideFallback() else ShowFallback(entries) end
    end
end

-- ── Placeholder mod entries (replace with real registry data) ─────────────
local function GetModEntries()
    return {
        { name="AMC Client Mod",  status="ok",       version="v0.2.10" },
        { name="SomePak v1.2",    status="outdated",  version="v1.0"   },
        { name="MissingMod",      status="missing",   version=""        },
    }
end

-- ── Lifecycle ─────────────────────────────────────────────────────────────
RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    ExecuteInGameThread(function()
        -- Reset all state on level change
        hudWidget = nil ; rootCanvas = nil ; textBlock = nil
        luaVisible = false ; activeBpWidget = nil ; rowCounter = 0
        bpManagerClass = nil ; bpEntryClass = nil
        BuildFallbackWidget()
        ProbePakWidgets()
    end)
end)

RegisterKeyBind(Key.M, {ModifierKey.CONTROL}, function()
    ExecuteInGameThread(function()
        Toggle(GetModEntries())
    end)
end)

return {
    Toggle          = Toggle,
    ProbePak        = ProbePakWidgets,
    GetModEntries   = GetModEntries,
    IsPakLoaded     = function() return bpManagerClass ~= nil end,
    GetManagerClass = function() return bpManagerClass end,
    GetEntryClass   = function() return bpEntryClass   end,
}
