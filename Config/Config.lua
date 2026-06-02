-------------------------------------------------------------------------------
-- Project: AscensionMasque
-- Author: Aka-DoctorCode
-- File: Config.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, addonTable = ...

-------------------------------------------------------------------------------
-- COMPONENT HELPERS
-------------------------------------------------------------------------------
-- Prevents duplicate UI elements if the user re-enters the tab
local function guardedBuild(panel, buildFn)
    if panel.contentBuilt then return end
    panel.contentBuilt = true
    buildFn(panel)
end

-------------------------------------------------------------------------------
-- TAB CONSTRUCTION
-------------------------------------------------------------------------------
local function buildSettingsTab(ctx, db)
    return function(panel)
        guardedBuild(panel, function(p)
            local layout = ctx:createLayoutModel(p.content, -10)

            -- Column 1
            layout:beginColumn(5, 260)
            
            layout:header("hotkeyHeader", "Hotkey Labels")
            layout:beginSection()

            layout:checkbox(
                "hotkeyClean",
                "Enable Hotkey Cleaning",
                "Abbreviate hotkey labels (e.g. Shift-1 \226\134\146 S1, Mouse Wheel Up \226\134\146 WU)",
                function() return db.enableHotkeyClean end,
                function(value) db.enableHotkeyClean = value end,
                10
            )

            layout:slider(
                "hotkeySize",
                "Hotkey Text Size",
                "Font size for keybind labels on action buttons",
                8, 24, 1,
                function() return db.hotkeyFontSize end,
                function(value)
                    db.hotkeyFontSize = value
                    if addonTable.applyFontSizes then addonTable.applyFontSizes(db) end
                end,
                220,
                25
            )

            layout:slider(
                "countSize",
                "Count Text Size",
                "Font size for item/spell count on action buttons",
                8, 24, 1,
                function() return db.countFontSize end,
                function(value)
                    db.countFontSize = value
                    if addonTable.applyFontSizes then addonTable.applyFontSizes(db) end
                end,
                220,
                25
            )

            layout:endSection()

            layout:header("layoutHeader", "Icon Zoom")
            layout:beginSection()

            layout:label("reloadNote",
                "|cFFFF9900Requires /reload to take effect.|r",
                10
            )

            layout:slider(
                "iconZoom",
                "Icon Zoom (1:1 skin)",
                "Crop the icon texture inward. Higher = more zoomed. Square skin only.",
                0, 0.2, 0.01,
                function() return db.iconZoom end,
                function(value) db.iconZoom = value end,
                220,
                25
            )

            layout:endSection()
            layout:endColumn()

            -- Column 2
            layout:beginColumn(275, 260)
            
            layout:header("posHeader", "Label Position")
            layout:beginSection()

            layout:slider(
                "hotkeyOffX",
                "Hotkey Offset X",
                "Horizontal position of the hotkey label",
                -20, 20, 1,
                function() return db.hotkeyOffsetX end,
                function(value)
                    db.hotkeyOffsetX = value
                    if addonTable.applyTextOffsets then addonTable.applyTextOffsets(db) end
                end,
                220,
                295
            )

            layout:slider(
                "hotkeyOffY",
                "Hotkey Offset Y",
                "Vertical position of the hotkey label",
                -20, 20, 1,
                function() return db.hotkeyOffsetY end,
                function(value)
                    db.hotkeyOffsetY = value
                    if addonTable.applyTextOffsets then addonTable.applyTextOffsets(db) end
                end,
                220,
                295
            )

            layout:slider(
                "countOffX",
                "Count Offset X",
                "Horizontal position of the count label",
                -20, 20, 1,
                function() return db.countOffsetX end,
                function(value)
                    db.countOffsetX = value
                    if addonTable.applyTextOffsets then addonTable.applyTextOffsets(db) end
                end,
                220,
                295
            )

            layout:slider(
                "countOffY",
                "Count Offset Y",
                "Vertical position of the count label",
                -20, 20, 1,
                function() return db.countOffsetY end,
                function(value)
                    db.countOffsetY = value
                    if addonTable.applyTextOffsets then addonTable.applyTextOffsets(db) end
                end,
                220,
                295
            )

            layout:endSection()
            layout:endColumn()

            -- Triggers parent resize logic to ensure the scrollbar functions properly
            layout:columnsFinalize(p.content)
        end)
    end
end

-------------------------------------------------------------------------------
-- PANEL REGISTRATION
-------------------------------------------------------------------------------
-- Dynamically hooks into AscensionSuit-UI if loaded.
-- Yields control back to Core.lua fallback mechanism if unavailable.
addonTable.buildMasquePanel = function(db)
    local lib = LibStub and LibStub("AscensionSuit-UI", true)
    if not lib or not lib.Context or not lib.Context.createMainFrame then
        return false
    end

    local ctx = lib:CreateContext()

    local frame = ctx:createMainFrame({
        name      = "AscensionMasqueFrame",
        title     = "Ascension Masque",
        width     = 705,
        height    = 480,
        resizable = false,
        scrollable = false,
        tabNames  = { "Settings" },
        tabFuncs  = {
            buildSettingsTab(ctx, db),
        },
    })
    frame:Hide()

    -- CLI entrypoint
    SLASH_ASCENSIONMASQUE1 = "/am"
    SlashCmdList["ASCENSIONMASQUE"] = function()
        frame:SetShown(not frame:IsShown())
    end

    -- Injects a redirect button inside the default Blizzard Interface Options
    if lib.Integration and lib.Integration.registerBlizzardPanel then
        lib.Integration:registerBlizzardPanel(
            addonName,
            "Ascension Masque",
            function() frame:SetShown(not frame:IsShown()) end
        )
    end

    return true
end
