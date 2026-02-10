-------------------------------------------------------------------------------
-- Project: AscensionMasque
-- Author: Aka-DoctorCode 
-- File: AscensionMasque.lua
-- Version: 04
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

MSQ:AddSkin("Ascension Wide", {
    Shape = "Square",
    Template = "Blizzard Classic",

    Author = "AkaDoctorCode",
    Description = "A 16:9 widescreen version of the Ascension skin.",
    Version = "1.0",

    Backdrop = {
        Color = {0, 0, 0, 0.5},
        UseColor = true,
    },
    
    Icon = {
        TexCoords = {0.07, 0.93, 0.25, 0.75},
        Width = 68,
        Height = 38,
    },
    
    Normal = _Hidden,

    Pushed = {
        Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
        DrawLevel = 1,
        Width = 68,
        Height = 38,
    },
    Checked = {
        Texture = [[Interface\Buttons\CheckButtonHilight]],
        BlendMode = STR_ADD,
        Width = 68,
        Height = 38,
    },
    SlotHighlight = "Checked",
    
    Border = {
        Texture = [[Interface\Buttons\UI-ActionButton-Border]],
        BlendMode = STR_ADD,
        Width = 118,
        Height = 66,
        OffsetX = 0.5,
        OffsetY = 0.5,
        Debuff = {
            Texture = TEX_DEBUFF,
            TexCoords = {0.296875, 0.5703125, 0, 0.515625},
            Width = 71,
            Height = 38,
        },
        Enchant = {
            Texture = TEX_ENCHANT,
            Width = 71,
            Height = 40,
        },
        Item = {
            Texture = [[Interface\Common\WhiteIconFrame]],
            Width = 68,
            Height = 38,
        },
    },
    DebuffBorder = {
        Texture = TEX_DEBUFF,
        TexCoords = {0.296875, 0.5703125, 0, 0.515625},
        Width = 71,
        Height = 38,
    },
    EnchantBorder = {
        Texture = TEX_ENCHANT,
        Width = 71,
        Height = 40,
    },
    IconBorder = {
        Texture = [[Interface\Common\WhiteIconFrame]],
        RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
        Width = 68,
        Height = 38,
    },
    
    NewAction = {
        Atlas = "bags-newitem",
        Width = 82,
        Height = 46,
    },
    SpellHighlight = "NewAction",
    IconOverlay = {
        Atlas = "AzeriteIconFrame",
        Width = 68,
        Height = 38,
    },
    IconOverlay2 = {
        Atlas = "ConduitIconFrame-Corners",
        Width = 68,
        Height = 38,
    },
    
    ContextOverlay = {
        Color = {0, 0, 0, 0.8},
        Width = 68,
        Height = 38,
        UseColor = true,
    },
    SearchOverlay = "ContextOverlay",
    
    Count = {
        Width = 64,
        Height = 10,
        OffsetX = -2,
        OffsetY = 2,
        JustifyH = "RIGHT",
        JustifyV = "BOTTOM",
    },
    HotKey = {
        Width = 64,
        Height = 10,
		OffsetX = 2,
        OffsetY = -2,
        JustifyH = "LEFT",
        JustifyV = "TOP",
    },
    Duration = {
        Width = 64,
        Height = 10,
        OffsetX = 0,
        OffsetY = 2,
        JustifyH = "CENTER",
        JustifyV = "BOTTOM",
    },
    Name = {
        Width = 68,
        Height = 10,
        OffsetX = 0,
        OffsetY = 2,
        JustifyH = "CENTER",
        JustifyV = "BOTTOM",
    },

    AutoCastable = {
        Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        Width = 118,
        Height = 66,
        OffsetX = 0.5,
        OffsetY = -0.5,
    },
    AutoCastShine = {
        Width = 64,
        Height = 36,
        OffsetX = 0.5,
        OffsetY = -0.5
    },
    AutoCast_Mask = {
        Texture = [[Interface\AddOns\Masque\Textures\Square\AutoCast-Mask]],
        Width = 60,
        Height = 34,
    },
    AutoCast_Corners = {
        Atlas = "UI-HUD-ActionBar-PetAutoCast-Corners",
        Width = 68,
        Height = 38,
    },
    
    SpellAlert = {
        Width = 71,
        Height = 40,
        AltGlow = {
            Height = 46,
            Width = 82,
        },
        Classic = {
            Height = 34,
            Width = 60,
        },
        Modern = {
            Height = 34,
            Width = 60,
        },
        ["Modern-Lite"] = {
            Height = 33,
            Width = 59,
        },
    },
    AssistedCombatHighlight = {
        Width = 82,
        Height = 46,
    },
}, true)