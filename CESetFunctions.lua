CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped
local LSD = LibSetDetection


--DEBUG--
--function CE.DEBUG()
--    EVENT_MANAGER:RegisterForEvent(CE.name, EVENT_RETICLE_TARGET_CHANGED, CE.EquippedSetInfo)
--end

function CE.DelayUpdate(initial)
    local delay = 1500
    zo_callLater(function() CE.EquippedSetInfo() end, delay)
end

--Breaks table returned by GetEquippedSetsList() into 3 more manageable tables
function CE.EquippedSetInfo()
    CE.equip_sets = LSD.GetEquippedSetsTable()

    --Reset tables for next UI update
    CE.set_names = {}
    CE.set_max_equip = {}
    CE.set_num_equip = {}
    CE.num_str = {}
    
    --setID -> setName, maxEquip, numEquip{}, table.insert(table, value)
    for setID, info in pairs(CE.equip_sets) do 
        table.insert(CE.set_names, info["setName"])
        table.insert(CE.set_max_equip, info["maxEquipped"])

        --If body pieces, add them, if weapons, add highest value, otherwise double barred set will add front and back
        local tot_equip = 0
        local temp_bar = 0
        for loc, num_equip in pairs(info["numEquipped"]) do
            if loc == "body" then 
                tot_equip = tot_equip + num_equip
            elseif num_equip > temp_bar then -- >= ?
                tot_equip = (tot_equip + num_equip) - temp_bar
                temp_bar = num_equip
            end            
        end
        table.insert(CE.set_num_equip, tot_equip)
    end
    CE.FormatStrings()
    CE.UpdateUI()
end

--NOTE: need to reset num_str after use
function CE.FormatStrings()
    --init, max, step
    for i=1, table.getn(CE.set_names), 1 do
        table.insert(CE.num_str, CE.set_num_equip[i] .. "/" .. CE.set_max_equip[i])
    end
end 

function CE.UpdateUI()
    CE.ResetUI()
    if CE.show_UI then CEFrame:SetHidden(false) end
    for i=1, table.getn(CE.set_names), 1 do
        CE.rows[i].nums:SetText(CE.num_str[i])
        CE.rows[i].names:SetText(CE.set_names[i])    
        
        if (CE.set_num_equip[i] == CE.set_max_equip[i]) then
            CE.rows[i].nums:SetColor(unpack(CE.comp_color))
            CE.rows[i].names:SetColor(unpack(CE.comp_color))
        else
            CE.rows[i].nums:SetColor(unpack(CE.incomp_color))
            CE.rows[i].names:SetColor(unpack(CE.incomp_color))
        end

        CE.rows[i].enabled = true
        CE.rows[i]:SetHidden(false)
    end
    CEFrameTitle:SetColor(unpack(CE.head_color))
end

--Need to resetUI when a set is removed so that extra row is removed
function CE.ResetUI()
    for i=1, CE.max_rows, 1 do
        CE.rows[i]:SetHidden(true)
    end 
end