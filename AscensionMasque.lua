local MSQ = LibStub("Masque", true)
if not MSQ then return end

local _Hidden = {
    Hide = true,
}

local TEX_DEBUFF = [[Interface\Buttons\UI-Debuff-Overlays]]
local TEX_ENCHANT = [[Interface\Buttons\UI-TempEnchant-Border]]
local STR_ADD = "ADD"

MSQ:AddSkin("Ascension", {
    Shape = "Square",
    Template = "Blizzard Classic",

    Author = "AkaDoctorCode",
    Description = "A version of Zoomed with adjusted text.",
    Version = "1.0",

    Backdrop = {
        Color = {0, 0, 0, 0.5},
        UseColor = true,
    },
    Icon = {
        TexCoords = {0.07, 0.93, 0.07, 0.93},
    },
    
    Normal = _Hidden,

    Pushed = {
        Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
        DrawLevel = 1,
        Width = 38,
        Height = 38,
    },
    Checked = {
        Texture = [[Interface\Buttons\CheckButtonHilight]],
        BlendMode = STR_ADD,
        Width = 38,
        Height = 38,
    },
    SlotHighlight = "Checked",
    
    Border = {
        Texture = [[Interface\Buttons\UI-ActionButton-Border]],
        BlendMode = STR_ADD,
        Width = 66,
        Height = 66,
        OffsetX = 0.5,
        OffsetY = 0.5,
        Debuff = {
            Texture = TEX_DEBUFF,
            TexCoords = {0.296875, 0.5703125, 0, 0.515625},
            Width = 40,
            Height = 38,
        },
        Enchant = {
            Texture = TEX_ENCHANT,
            Width = 40,
            Height = 40,
        },
        Item = {
            Texture = [[Interface\Common\WhiteIconFrame]],
            Width = 38,
            Height = 38,
        },
    },
    DebuffBorder = {
        Texture = TEX_DEBUFF,
        TexCoords = {0.296875, 0.5703125, 0, 0.515625},
        Width = 40,
        Height = 38,
    },
    EnchantBorder = {
        Texture = TEX_ENCHANT,
        Width = 40,
        Height = 40,
    },
    IconBorder = {
        Texture = [[Interface\Common\WhiteIconFrame]],
        RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
        Width = 38,
        Height = 38,
    },
    
    NewAction = {
        Atlas = "bags-newitem",
        Width = 46,
        Height = 46,
    },
    SpellHighlight = "NewAction",
    IconOverlay = {
        Atlas = "AzeriteIconFrame",
        Width = 38,
        Height = 38,
    },
    IconOverlay2 = {
        Atlas = "ConduitIconFrame-Corners",
        Width = 38,
        Height = 38,
    },
    
    ContextOverlay = {
        Color = {0, 0, 0, 0.8},
        Width = 38,
        Height = 38,
        UseColor = true,
    },
    SearchOverlay = "ContextOverlay",
    
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
        Height = 66,
        OffsetX = 0.5,
        OffsetY = -0.5,
    },
    AutoCastShine = {
        Width = 36,
        Height = 36,
        OffsetX = 0.5,
        OffsetY = -0.5
    },
    AutoCast_Mask = {
        Texture = [[Interface\AddOns\Masque\Textures\Square\AutoCast-Mask]],
        Width = 34,
        Height = 34,
    },
    AutoCast_Corners = {
        Atlas = "UI-HUD-ActionBar-PetAutoCast-Corners",
        Width = 38,
        Height = 38,
    },
    
    SpellAlert = {
        Width = 40,
        Height = 40,
        AltGlow = {
            Height = 46,
            Width = 46,
        },
        Classic = {
            Height = 34,
            Width = 34,
        },
        Modern = {
            Height = 34,
            Width = 34,
        },
        ["Modern-Lite"] = {
            Height = 33,
            Width = 33,
        },
    },
    AssistedCombatHighlight = {
        Width = 46,
        Height = 46,
    },
}, true)

local function CleanText(text)
    if not text or text == "" then return nil end
    local newText = text

    newText = newText:gsub("s%-", "S")
    newText = newText:gsub("c%-", "C")
    newText = newText:gsub("a%-", "A")
	newText = newText:gsub("m%-", "M")
    newText = newText:gsub("Middle Mouse", "MM")
    newText = newText:gsub("Mouse Wheel", "MW")
    newText = newText:gsub("Mouse Button", "MB") 
    newText = newText:gsub("MouseButton", "MB")
	newText = newText:gsub("(%a)%s+(%d)", "%1%2")

    return newText
end

local function HookRegion(fontString)
    if not fontString or fontString.IsSkinnedByMe then return end
    fontString.IsSkinnedByMe = true
    
    hooksecurefunc(fontString, "SetText", function(self, text)
        if not text then return end
        local clean = CleanText(text)
        if clean and clean ~= text then
            self:SetText(clean)
        end
    end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    local barNames = {
        "ActionButton", 
        "MultiBarBottomLeftButton", 
        "MultiBarBottomRightButton", 
        "MultiBarLeftButton", 
        "MultiBarRightButton", 
        "PetActionButton",
        "StanceButton"
    }
    
    for _, barName in pairs(barNames) do
        for i = 1, 12 do
            local btn = _G[barName..i]
            if btn and btn.HotKey then
                HookRegion(btn.HotKey)
                
                local current = btn.HotKey:GetText()
                if current then
                    local clean = CleanText(current)
                    if clean ~= current then
                        btn.HotKey:SetText(clean)
                    end
                end
            end
        end
    end
end)