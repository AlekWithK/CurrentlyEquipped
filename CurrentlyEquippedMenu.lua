CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped

function CE.AddonMenu()

    local menuOptions = {
        type = "panel",
        name = CE.name,
        displayName = "Currently Equipped Gear",
        author = CE.author,
        version = CE.version,
        slashCommand = "/ce",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local dataTable = {
        {
            type = "description",
            text = "Displays your currently equipped sets, with colors indicating their status."
        },
        {
            type = "header",
            name = "Settings",
            width = "full",
        },
        {
			type    = "checkbox",
			name    = "Unlock UI",
			tooltip = "Toggle 'On' to move display's on screen position",
			default = false,
			getFunc = function() return false end,
			setFunc = function(newVal) CE.MoveUI() CE.unlockedUI = not newVal; end,
		},


    }

    LAM = LibAddonMenu2
	LAM:RegisterAddonPanel(CE.name .. "Options", menuOptions)
	LAM:RegisterOptionControls(CE.name .. "Options", dataTable)
end