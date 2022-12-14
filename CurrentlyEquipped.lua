CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped
CE.name = "CurrentlyEquipped"
CE.author = "|c1cf9e4A|r|c39f3cal|r|c55eeb1e|r|c71e897k|r|c8ee27dW|r|caadc63i|r|cc6d74at|r|ce3d130h|r|cffcb16K|r"
CE.version = "1.0.0"

CE.defaults = {}

--Addon initialize
function CE.Init()
    d("CE Loaded!")
end

--function CE.registerEvents()
--function CE.loadDefaults()

--Addon startup
function CE.OnAddonLoaded(event, addonName)
    if addonName == CE.name then
        CE.Init()
        EVENT_MANAGER:UnregisterForEvent(CE.name, EVENT_ADD_ON_LOADED)
    end 
end 

EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_ADD_ON_LOADED, CE.OnAddOnLoaded)