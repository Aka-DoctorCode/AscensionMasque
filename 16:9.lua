-------------------------------------------------------------------------------
-- Project: AscensionMasque
-- Author: Aka-DoctorCode 
-- File: 16:9.lua
-- Version: 06
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in 
-- derivative works without express written permission.
-------------------------------------------------------------------------------
local MSQ = LibStub("Masque", true)
if not MSQ then return end

local _Hidden = {
    Hide = true,
}

local TEX_DEBUFF = [[Interface\Buttons\UI-Debuff-Overlays]]
local TEX_ENCHANT = [[Interface\Buttons\UI-TempEnchant-Border]]
local STR_ADD = "ADD"

-- Registered as "Ascension Wide"
MSQ:AddSkin("Ascension Wide", {
    Shape = "Square",
    Template = "Blizzard Classic",

    Author = "AkaDoctorCode",
    Description = "A 16:9 widescreen version (38x21).",
    Version = "1.1",

    Backdrop = {
        Color = {0, 0, 0, 0.5},
        UseColor = true,
    },
    
    -- Width kept at 38, Height reduced to 21 to achieve 16:9 ratio
    -- TexCoords cropped vertically to prevent the image from looking squashed
    Icon = {
        TexCoords = {0.07, 0.93, 0.26, 0.74}, 
        Width = 38,
        Height = 25,
    },
    
    Normal = _Hidden,

    Pushed = {
        Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
        DrawLevel = 1,
        Width = 38,
        Height = 25,
    },
    Checked = {
        Texture = [[Interface\Buttons\CheckButtonHilight]],
        BlendMode = STR_ADD,
        Width = 38,
        Height = 25,
    },
    SlotHighlight = "Checked",
    
    -- Borders scaled down proportionally
    Border = {
        Texture = [[Interface\Buttons\UI-ActionButton-Border]],
        BlendMode = STR_ADD,
        Width = 66,
        Height = 37, 
        OffsetX = 0.5,
        OffsetY = 0.5,
        Debuff = {
            Texture = TEX_DEBUFF,
            TexCoords = {0.296875, 0.5703125, 0, 0.515625},
            Width = 40,
            Height = 25,
        },
        Enchant = {
            Texture = TEX_ENCHANT,
            Width = 40,
            Height = 22,
        },
        Item = {
            Texture = [[Interface\Common\WhiteIconFrame]],
            Width = 38,
            Height = 25,
        },
    },
    DebuffBorder = {
        Texture = TEX_DEBUFF,
        TexCoords = {0.296875, 0.5703125, 0, 0.515625},
        Width = 40,
        Height = 25,
    },
    EnchantBorder = {
        Texture = TEX_ENCHANT,
        Width = 40,
        Height = 22,
    },
    IconBorder = {
        Texture = [[Interface\Common\WhiteIconFrame]],
        RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
        Width = 38,
        Height = 25,
    },
    
    NewAction = {
        Atlas = "bags-newitem",
        Width = 46,
        Height = 26,
    },
    SpellHighlight = "NewAction",
    IconOverlay = {
        Atlas = "AzeriteIconFrame",
        Width = 38,
        Height = 25,
    },
    IconOverlay2 = {
        Atlas = "ConduitIconFrame-Corners",
        Width = 38,
        Height = 25,
    },
    
    ContextOverlay = {
        Color = {0, 0, 0, 0.8},
        Width = 38,
        Height = 25,
        UseColor = true,
    },
    SearchOverlay = "ContextOverlay",
    
    -- Text fields adjusted for the tighter vertical space
    Count = {
        Width = 36,
        Height = 10,
        OffsetX = -1,
        OffsetY = 1,
        JustifyH = "RIGHT",
        JustifyV = "BOTTOM",
    },
    HotKey = {
        Width = 40,
        Height = 10,
        OffsetX = 0,
        OffsetY = 0,
        JustifyH = "LEFT",
        JustifyV = "TOP",
    },
    Duration = {
        Width = 36,
        Height = 10,
        OffsetX = 0,
        OffsetY = 1,
        JustifyH = "CENTER",
        JustifyV = "BOTTOM",
    },
    Name = {
        Width = 36,
        Height = 10,
        OffsetX = 0,
        OffsetY = 1,
        JustifyH = "CENTER",
        JustifyV = "BOTTOM",
    },

    AutoCastable = {
        Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        Width = 66,
        Height = 37,
        OffsetX = 0.5,
        OffsetY = -0.5,
    },
    AutoCastShine = {
        Width = 36,
        Height = 20,
        OffsetX = 0.5,
        OffsetY = -0.5
    },
    AutoCast_Mask = {
        Texture = [[Interface\AddOns\Masque\Textures\Square\AutoCast-Mask]],
        Width = 34,
        Height = 19,
    },
    AutoCast_Corners = {
        Atlas = "UI-HUD-ActionBar-PetAutoCast-Corners",
        Width = 38,
        Height = 25,
    },
    
    SpellAlert = {
        Width = 40,
        Height = 22,
        AltGlow = {
            Height = 26,
            Width = 46,
        },
        Classic = {
            Height = 19,
            Width = 34,
        },
        Modern = {
            Height = 19,
            Width = 34,
        },
        ["Modern-Lite"] = {
            Height = 18,
            Width = 33,
        },
    },
    AssistedCombatHighlight = {
        Width = 46,
        Height = 26,
    },
}, true)