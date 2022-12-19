CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped
CE.name = "CurrentlyEquipped"
CE.author = "|c1cf9e4A|r|c39f3cal|r|c55eeb1e|r|c71e897k|r|c8ee27dW|r|caadc63i|r|cc6d74at|r|ce3d130h|r|cffcb16K|r"
CE.version = "1.0.0"

----------------------------
-----### CONSTANTS ###-----
----------------------------
CE.lockedUI = true
CE.hideInCombat = true
CE.show_in_zone = false
CE.show_UI = false
CE.x_offset = 1000
CE.y_offset = 500
CE.max_rows = 6
CE.rows = {}

CE.head_color = {0.8353, 0.7922, 0.8039, 1} --white
CE.comp_color = {0.4941, 1, 0.5098, 1} --green
CE.incomp_color = {1, 0.3490, 0.2706, 1} --red

local TRIAL_ZONE_IDS = {
    [636] = true, -- Hel Ra Citadel
    [638] = true, -- Aetherian Archive
    [639] = true, -- Sanctum Ophidia
    [725] = true, -- Maw of Lorkhaj
    [975] = true, -- Halls of Fabrication
    [1000] = true, -- Asylum Sanctorium
    [1051] = true, -- Cloudrest
    [1121] = true, -- Sunspire
    [1196] = true, -- Kyne's Aegis
    [1344] = true -- Dreadsail Reef
}

local ARENA_ZONE_IDS = {
    [635] = true, -- Dragonstar Arena
    [677] = true, -- Maelstrom Arena
    [1082] = true, -- Blackrose Prison
    [1227] = true -- Vateshran Hollows
}

----------------------------
---### INITIALIZATION ###---
----------------------------
function CE.Init()
    CE.savedVariables = ZO_SavedVars:NewAccountWide("CurrentlyEquippedSavedVariables", 1, nil, {})

    CE.AddonMenu() 
    CE.RestoreDefaults()
    CE.InitUI()
    CE.RestorePos() 
    --CE.DEBUG()
end

--Restore defaults (must use IF if boolean)
function CE.RestoreDefaults()
    if CE.savedVariables.hideInCombat ~= nil then CE.hideInCombat = CE.savedVariables.hideInCombat end
    if CE.savedVariables.show_in_zone ~= nil then CE.show_in_zone = CE.savedVariables.show_in_zone end
    CE.head_color = CE.savedVariables.head_color or CE.head_color
    CE.comp_color = CE.savedVariables.comp_color or CE.comp_color
    CE.incomp_color = CE.savedVariables.incomp_color or CE.incomp_color
end

function CE.InitUI()
    for i=1, CE.max_rows, 1 do
        CE.rows[i] = CEFrame:GetNamedChild("Row" .. i)
        CE.rows[i].nums = CE.rows[i]:GetNamedChild("Nums")
        CE.rows[i].names = CE.rows[i]:GetNamedChild("Names")

        CE.rows[i].enabled = false;
    end
    CEFrameTitle:SetColor(unpack(CE.head_color))
end

--Restore UI position
function CE.RestorePos()
    local left = CE.savedVariables.left or CE.x_offset
    local top = CE.savedVariables.top or CE.y_offset

    CEFrame:ClearAnchors()
    CEFrame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

--Register events
function CE.RegisterEvents()
    EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_PLAYER_COMBAT_STATE, CE.HideUICombat)
    EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_PLAYER_ACTIVATED, CE.PlayerActivate)
    EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, CE.DelayUpdate)
    EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_PLAYER_DEACTIVATED, CE.ReloadDelay)

    --Filters keep event from firing twice on gear swap or on non-gear inv change
    EVENT_MANAGER:AddFilterForEvent(CE.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
    EVENT_MANAGER:AddFilterForEvent(CE.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_IS_NEW_ITEM, false)
    EVENT_MANAGER:AddFilterForEvent(CE.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON , INVENTORY_UPDATE_REASON_DEFAULT)
end

function CE.PlayerActivate(_, initial)
    local curr_zone_id = GetZoneId(GetUnitZoneIndex("player"))
    --Only show display in Trial/Arenas, don't update data either
    if CE.show_in_zone and not (TRIAL_ZONE_IDS[curr_zone_id] or ARENA_ZONE_IDS[curr_zone_id]) then
        CE.show_UI = false
        CEFrame:SetHidden(true)
        return
    else
        CE.show_UI = true
    end
    CE.DelayUpdate(initial)
end

----------------------------
---### MENU FUNCTIONS ###---
----------------------------
function CE.MoveUI()
    if CE.lockedUI then CEFrame:SetMovable(true)
    else CEFrame:SetMovable(false) end
end

function CE.HideUICombat()
    local inCombat = IsUnitInCombat("player")

    if inCombat and CE.hideInCombat then CEFrame:SetHidden(true)
    else CEFrame:SetHidden(false) end
end

----------------------------
---### SAVE VARIABLES ###---
----------------------------
function CE.SavePos()
    CE.savedVariables.left = CEFrame:GetLeft()
    CE.savedVariables.top = CEFrame:GetTop()
end

function CE.SaveHideInCombat(bool)
    CE.savedVariables.hideInCombat = bool end

function CE.SaveShowInZone(bool)
    CE.savedVariables.show_in_zone = bool end

function CE.SaveHeadColor(r, g, b, a)
    CE.savedVariables.head_color = {r, g, b, a}
    CE.head_color = {r, g, b, a}
    CE.UpdateUI()
end

function CE.SaveCompColor(r, g, b, a)
    CE.savedVariables.comp_color = {r, g, b, a}
    CE.comp_color = {r, g, b, a}
    CE.UpdateUI()
end

function CE.SaveIncompColor(r, g, b, a)
    CE.savedVariables.incomp_color = {r, g, b, a}
    CE.incomp_color = {r, g, b, a}
    CE.UpdateUI()
end

--Addon startup
function CE.OnAddOnLoaded(_, addonName)
    if addonName ~= CE.name then return end

    EVENT_MANAGER:UnregisterForEvent(CE.name, EVENT_ADD_ON_LOADED)
    CE.RegisterEvents()
    CE.Init()
end 

EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_ADD_ON_LOADED, CE.OnAddOnLoaded)