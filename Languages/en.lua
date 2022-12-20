--Localization support required for keybindings
local loc_strings = {
    SI_BINDING_NAME_REFRESH_UI = "Reset Display",
}

for str_id, str in pairs(loc_strings) do
    ZO_CreateStringId(str_id, str)
    SafeAddVersion(str_id, 1)
end