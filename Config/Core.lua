-------------------------------------------------------------------------------
-- Project: AscensionMasque
-- File: Core.lua
-- Shared namespace, config, hotkey hook system, and options panel.
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, addonTable = ...

-------------------------------------------------------------------------------
-- EXPORTS
-------------------------------------------------------------------------------
addonTable.hiddenLayer = { Hide = true }
addonTable.texDebuff   = [[Interface\Buttons\UI-Debuff-Overlays]]
addonTable.texEnchant  = [[Interface\Buttons\UI-TempEnchant-Border]]
addonTable.blendAdd    = "ADD"


-------------------------------------------------------------------------------
-- DEFAULT CONFIGURATION
-------------------------------------------------------------------------------
addonTable.defaults = {
    enableHotkeyClean = true,
    hotkeyFontSize    = 10,   -- HotKey label font size in points
    countFontSize     = 10,   -- Count label font size in points
    hotkeyOffsetX     = 0,    -- HotKey label horizontal offset in pixels
    hotkeyOffsetY     = 0,    -- HotKey label vertical offset in pixels
    countOffsetX      = -1,   -- Count label horizontal offset in pixels
    countOffsetY      = 1,    -- Count label vertical offset in pixels
    iconZoom          = 0.07, -- TexCoords edge offset for the 1:1 skin
}

-------------------------------------------------------------------------------
-- STATE MANAGEMENT
-------------------------------------------------------------------------------
-- Defers MSQ:AddSkin execution until SavedVariables are fully loaded
addonTable.skinRegistrationQueue = {}

-- Prevents taint by maintaining state externally rather than directly on Blizzard objects
local hookedFontStrings = {}

-------------------------------------------------------------------------------
-- Hotkey text cleaning
-------------------------------------------------------------------------------
local function cleanHotkeyText(text)
    if not text or type(text) ~= "string" or text == "" then return nil end
    local result = text
    result = result:gsub("s%-",             "S")
    result = result:gsub("c%-",             "C")
    result = result:gsub("a%-",             "A")
    result = result:gsub("m%-",             "M")
    result = result:gsub("Command",         "⌘")
    result = result:gsub("Middle Mouse",    "B3")
    result = result:gsub("Mouse Wheel Up",  "WU")
    result = result:gsub("Mouse Wheel Down","WD")
    result = result:gsub("Mouse Button",    "B")
    result = result:gsub("MouseButton",     "B")
    result = result:gsub("(%a)%s+(%d)",     "%1%2")
    return result
end

local function hookHotkeyFontString(fontString, db)
    if not fontString or hookedFontStrings[fontString] then return end
    hookedFontStrings[fontString] = true

    hooksecurefunc(fontString, "SetText", function(self, text)
        if not text or not db.enableHotkeyClean then return end
        local clean = cleanHotkeyText(text)
        if clean and clean ~= text then
            self:SetText(clean)
        end
    end)
end

local actionBarNames = {
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
    "MultiBarLeftButton",
    "MultiBarRightButton",
    "PetActionButton",
    "StanceButton",
}

local function applyHotkeyHooks(db)
    for _, barName in ipairs(actionBarNames) do
        for i = 1, 12 do
            local btn = _G[barName .. i]
            if btn and btn.HotKey then
                hookHotkeyFontString(btn.HotKey, db)
                if db.enableHotkeyClean then
                    local current = btn.HotKey:GetText()
                    if current then
                        local clean = cleanHotkeyText(current)
                        if clean and clean ~= current then
                            btn.HotKey:SetText(clean)
                        end
                    end
                end
            end
        end
    end
end

-------------------------------------------------------------------------------
-- FONT RENDERING
-------------------------------------------------------------------------------
local function setFontRegionSize(fontString, size)
    if not fontString then return end
    local path, _, flags = fontString:GetFont()
    if path then
        fontString:SetFont(path, size, flags or "")
    end
end

local function applyFontSizes(db)
    for _, barName in ipairs(actionBarNames) do
        for i = 1, 12 do
            local btn = _G[barName .. i]
            if btn then
                if btn.HotKey then
                    setFontRegionSize(btn.HotKey, db.hotkeyFontSize)
                end
                if btn.Count then
                    setFontRegionSize(btn.Count, db.countFontSize)
                end
            end
        end
    end
end
addonTable.applyFontSizes = applyFontSizes

local function applyTextOffsets(db)
    for _, barName in ipairs(actionBarNames) do
        for i = 1, 12 do
            local btn = _G[barName .. i]
            if btn then
                if btn.HotKey then
                    btn.HotKey:ClearAllPoints()
                    -- Mirrors Masque anchor for JustifyH=LEFT, JustifyV=TOP
                    btn.HotKey:SetPoint("TOPLEFT", btn, "TOPLEFT", db.hotkeyOffsetX, db.hotkeyOffsetY)
                end
                if btn.Count then
                    btn.Count:ClearAllPoints()
                    -- Mirrors Masque anchor for JustifyH=RIGHT, JustifyV=BOTTOM
                    btn.Count:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", db.countOffsetX, db.countOffsetY)
                end
            end
        end
    end
end
addonTable.applyTextOffsets = applyTextOffsets

-------------------------------------------------------------------------------
-- FALLBACK INTERFACE
-------------------------------------------------------------------------------
-- Provides native Settings API integration if AscensionSuit is unavailable.
-- RegisterProxySetting ensures bidirectional synchronization with the database.
local function buildOptionsPanel(db)
    if not Settings or not Settings.RegisterVerticalLayoutCategory then return end

    local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)

    -- Section: Hotkey Labels
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Hotkey Labels"))

    local cleanSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_enableHotkeyClean",
        Settings.VarType.Boolean,
        "Enable Hotkey Cleaning",
        db.enableHotkeyClean,
        function() return db.enableHotkeyClean end,
        function(value) db.enableHotkeyClean = value end
    )
    Settings.CreateCheckbox(
        category, cleanSetting,
        "Abbreviate hotkey labels (e.g. Shift-1 \226\134\146 S1, Mouse Wheel Up \226\134\146 WU)"
    )

    -- Hotkey font size slider (runtime — no reload needed)
    local hotkeySizeSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_hotkeyFontSize",
        Settings.VarType.Number,
        "Hotkey Text Size",
        db.hotkeyFontSize,
        function() return db.hotkeyFontSize end,
        function(value)
            db.hotkeyFontSize = value
            applyFontSizes(db)
        end
    )
    local hotkeyFontSlider = Settings.CreateSliderOptions(8, 24, 1)
    hotkeyFontSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpt", value) end
    )
    Settings.CreateSlider(
        category, hotkeySizeSetting, hotkeyFontSlider,
        "Font size for keybind labels on action buttons"
    )

    -- Count font size slider (runtime — no reload needed)
    local countSizeSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_countFontSize",
        Settings.VarType.Number,
        "Count Text Size",
        db.countFontSize,
        function() return db.countFontSize end,
        function(value)
            db.countFontSize = value
            applyFontSizes(db)
        end
    )
    local countFontSlider = Settings.CreateSliderOptions(8, 24, 1)
    countFontSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpt", value) end
    )
    Settings.CreateSlider(
        category, countSizeSetting, countFontSlider,
        "Font size for item/spell count on action buttons"
    )

    -- Hotkey offset X (runtime)
    local hotkeyOffsetXSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_hotkeyOffsetX",
        Settings.VarType.Number,
        "Hotkey Offset X",
        db.hotkeyOffsetX,
        function() return db.hotkeyOffsetX end,
        function(value)
            db.hotkeyOffsetX = value
            applyTextOffsets(db)
        end
    )
    local hotkeyOffsetXSlider = Settings.CreateSliderOptions(-20, 20, 1)
    hotkeyOffsetXSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpx", value) end
    )
    Settings.CreateSlider(
        category, hotkeyOffsetXSetting, hotkeyOffsetXSlider,
        "Horizontal position offset of the hotkey label"
    )

    -- Hotkey offset Y (runtime)
    local hotkeyOffsetYSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_hotkeyOffsetY",
        Settings.VarType.Number,
        "Hotkey Offset Y",
        db.hotkeyOffsetY,
        function() return db.hotkeyOffsetY end,
        function(value)
            db.hotkeyOffsetY = value
            applyTextOffsets(db)
        end
    )
    local hotkeyOffsetYSlider = Settings.CreateSliderOptions(-20, 20, 1)
    hotkeyOffsetYSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpx", value) end
    )
    Settings.CreateSlider(
        category, hotkeyOffsetYSetting, hotkeyOffsetYSlider,
        "Vertical position offset of the hotkey label"
    )

    -- Count offset X (runtime)
    local countOffsetXSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_countOffsetX",
        Settings.VarType.Number,
        "Count Offset X",
        db.countOffsetX,
        function() return db.countOffsetX end,
        function(value)
            db.countOffsetX = value
            applyTextOffsets(db)
        end
    )
    local countOffsetXSlider = Settings.CreateSliderOptions(-20, 20, 1)
    countOffsetXSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpx", value) end
    )
    Settings.CreateSlider(
        category, countOffsetXSetting, countOffsetXSlider,
        "Horizontal position offset of the item/spell count label"
    )

    -- Count offset Y (runtime)
    local countOffsetYSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_countOffsetY",
        Settings.VarType.Number,
        "Count Offset Y",
        db.countOffsetY,
        function() return db.countOffsetY end,
        function(value)
            db.countOffsetY = value
            applyTextOffsets(db)
        end
    )
    local countOffsetYSlider = Settings.CreateSliderOptions(-20, 20, 1)
    countOffsetYSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%dpx", value) end
    )
    Settings.CreateSlider(
        category, countOffsetYSetting, countOffsetYSlider,
        "Vertical position offset of the item/spell count label"
    )

    -- Section: Skin Layout (requires /reload)
    layout:AddInitializer(
        CreateSettingsListSectionHeaderInitializer("Skin Layout  \194\183  Requires /reload")
    )

    -- Icon zoom
    local zoomSetting = Settings.RegisterProxySetting(
        category,
        "AscensionMasque_iconZoom",
        Settings.VarType.Number,
        "Icon Zoom (1:1 skin)",
        db.iconZoom,
        function() return db.iconZoom end,
        function(value) db.iconZoom = value end
    )
    local zoomSlider = Settings.CreateSliderOptions(0, 0.2, 0.01)
    zoomSlider:SetLabelFormatter(
        MinimalSliderWithSteppersMixin.Label.Right,
        function(value) return string.format("%.0f%%", value * 500) end
    )
    Settings.CreateSlider(
        category, zoomSetting, zoomSlider,
        "How much to crop the icon texture inward (higher = more zoomed in). Square skin only."
    )

    Settings.RegisterAddOnCategory(category)
end

-------------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------------
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 ~= addonName then return end
        self:UnregisterEvent("ADDON_LOADED")

        AscensionMasqueDB = AscensionMasqueDB or {}
        local db = AscensionMasqueDB
        for key, defaultValue in pairs(addonTable.defaults) do
            if db[key] == nil then
                db[key] = defaultValue
            end
        end
        addonTable.db = db

        for _, registerSkinFn in ipairs(addonTable.skinRegistrationQueue) do
            registerSkinFn(db)
        end

        local panelBuilt = addonTable.buildMasquePanel and addonTable.buildMasquePanel(db)
        if not panelBuilt then
            buildOptionsPanel(db)
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if addonTable.db then
            applyHotkeyHooks(addonTable.db)
            applyFontSizes(addonTable.db)
            -- Defer frame execution to guarantee Masque finishes its initial skin pass
            C_Timer.After(0, function()
                if addonTable.db then
                    applyTextOffsets(addonTable.db)
                end
            end)
        end
    end
end)
