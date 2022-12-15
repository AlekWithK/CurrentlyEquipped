CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped
CE.name = "CurrentlyEquipped"
CE.author = "|c1cf9e4A|r|c39f3cal|r|c55eeb1e|r|c71e897k|r|c8ee27dW|r|caadc63i|r|cc6d74at|r|ce3d130h|r|cffcb16K|r"
CE.version = "1.0.0"

--Move these?
CE.unlockedUI = true
CE.x_offset = 1000
CE.y_offset = 500

--Addon initialize
function CE.Init()
    CE.AddonMenu()

    CE.savedVariables = ZO_SavedVars:NewAccountWide("CurrentlyEquippedSavedVariables", 1, nil, {})
    
    --DEBUGGING
    --EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_RETICLE_TARGET_CHANGED, CE.SavePos)
    CE.RestorePos()
end

--Restore UI position
function CE.RestorePos()
    local left = CE.savedVariables.left or CE.x_offset
    local top = CE.savedVariables.top or CE.y_offset

    CEFrame:ClearAnchors()
    CEFrame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

--Move UI
function CE.MoveUI()
    if CE.unlockedUI then CEFrame:SetHidden(false)
    else CEFrame:SetHidden(true) end
end

--Save variables
function CE.SavePos()
    CE.savedVariables.left = CEFrame:GetLeft()
    CE.savedVariables.top = CEFrame:GetTop()
end

--Addon startup
function CE.OnAddOnLoaded(_, addonName)
    if addonName ~= CE.name then return end

    CE.Init()
    EVENT_MANAGER:UnregisterForEvent(CE.name, EVENT_ADD_ON_LOADED)
end 

EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_ADD_ON_LOADED, CE.OnAddOnLoaded)