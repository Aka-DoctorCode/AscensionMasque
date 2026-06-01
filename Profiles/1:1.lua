-------------------------------------------------------------------------------
-- Project: AscensionMasque
-- Author: Aka-DoctorCode
-- File: 1:1.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, addonTable = ...

local MSQ = LibStub("Masque", true)
if not MSQ then return end

-------------------------------------------------------------------------------
-- SKIN REGISTRATION
-------------------------------------------------------------------------------
-- Defers execution to guarantee DB availability before skin construction
table.insert(addonTable.skinRegistrationQueue, function(db)
    local zoom = db.iconZoom

    MSQ:AddSkin("Ascension", {
        Shape    = "Square",
        Template = "Blizzard Classic",

        Author      = "AkaDoctorCode",
        Description = "A version of Zoomed with adjusted text.",
        Version     = "2.0",

        Backdrop = {
            Color    = { 0, 0, 0, 0.5 }, -- #000000
            UseColor = true,
        },
        Icon = {
            TexCoords = { zoom, 1 - zoom, zoom, 1 - zoom },
        },

        Normal = addonTable.hiddenLayer,

        Pushed = {
            Texture   = [[Interface\Buttons\UI-Quickslot-Depress]],
            DrawLevel = 1,
            Width     = 38,
            Height    = 38,
        },
        Checked = {
            Texture   = [[Interface\Buttons\CheckButtonHilight]],
            BlendMode = addonTable.blendAdd,
            Width     = 38,
            Height    = 38,
        },
        SlotHighlight = "Checked",

        Border = {
            Texture   = [[Interface\Buttons\UI-ActionButton-Border]],
            BlendMode = addonTable.blendAdd,
            Width     = 66,
            Height    = 66,
            OffsetX   = 0.5,
            OffsetY   = 0.5,
            Debuff = {
                Texture   = addonTable.texDebuff,
                TexCoords = { 0.296875, 0.5703125, 0, 0.515625 },
                Width     = 40,
                Height    = 38,
            },
            Enchant = {
                Texture = addonTable.texEnchant,
                Width   = 40,
                Height  = 40,
            },
            Item = {
                Texture = [[Interface\Common\WhiteIconFrame]],
                Width   = 38,
                Height  = 38,
            },
        },
        DebuffBorder = {
            Texture   = addonTable.texDebuff,
            TexCoords = { 0.296875, 0.5703125, 0, 0.515625 },
            Width     = 40,
            Height    = 38,
        },
        EnchantBorder = {
            Texture = addonTable.texEnchant,
            Width   = 40,
            Height  = 40,
        },
        IconBorder = {
            Texture      = [[Interface\Common\WhiteIconFrame]],
            RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
            Width        = 38,
            Height       = 38,
        },

        NewAction = {
            Atlas  = "bags-newitem",
            Width  = 46,
            Height = 46,
        },
        SpellHighlight = "NewAction",
        IconOverlay = {
            Atlas  = "AzeriteIconFrame",
            Width  = 38,
            Height = 38,
        },
        IconOverlay2 = {
            Atlas  = "ConduitIconFrame-Corners",
            Width  = 38,
            Height = 38,
        },

        ContextOverlay = {
            Color    = { 0, 0, 0, 0.8 }, -- #000000
            Width    = 38,
            Height   = 38,
            UseColor = true,
        },
        SearchOverlay = "ContextOverlay",

        Count = {
            Width    = 36,
            Height   = 10,
            OffsetX  = -1,
            OffsetY  = 1,
            JustifyH = "RIGHT",
            JustifyV = "BOTTOM",
        },
        HotKey = {
            Width    = 40,
            Height   = 10,
            OffsetX  = 0,
            OffsetY  = 0,
            JustifyH = "LEFT",
            JustifyV = "TOP",
        },
        Duration = {
            Width    = 36,
            Height   = 10,
            OffsetX  = 0,
            OffsetY  = 1,
            JustifyH = "CENTER",
            JustifyV = "BOTTOM",
        },
        Name = {
            Width    = 36,
            Height   = 10,
            OffsetX  = 0,
            OffsetY  = 1,
            JustifyH = "CENTER",
            JustifyV = "BOTTOM",
        },

        AutoCastable = {
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
            Width   = 66,
            Height  = 66,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        AutoCastShine = {
            Width   = 36,
            Height  = 36,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        AutoCast_Mask = {
            Texture = [[Interface\AddOns\Masque\Textures\Square\AutoCast-Mask]],
            Width   = 34,
            Height  = 34,
        },
        AutoCast_Corners = {
            Atlas  = "UI-HUD-ActionBar-PetAutoCast-Corners",
            Width  = 38,
            Height = 38,
        },

        SpellAlert = {
            Width  = 40,
            Height = 40,
            AltGlow = {
                Height = 46,
                Width  = 46,
            },
            Classic = {
                Height = 34,
                Width  = 34,
            },
            Modern = {
                Height = 34,
                Width  = 34,
            },
            ["Modern-Lite"] = {
                Height = 33,
                Width  = 33,
            },
        },
        AssistedCombatHighlight = {
            Width  = 46,
            Height = 46,
        },
    }, true)
end)
