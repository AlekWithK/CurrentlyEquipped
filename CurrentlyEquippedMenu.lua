CurrentlyEquipped = CurrentlyEquipped or {}
local CE = CurrentlyEquipped

function CE.AddonMenu()

    local menuOptions = {
        type = "panel",
        name = CE.name,
        displayName = "Currently Equipped",
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
            name = "Options",
            width = "full",
        },
        {
			type    = "checkbox",
			name    = "Unlock UI",
			tooltip = "Toggle 'On' to move display's on screen position",
			default = false,
			getFunc = function() return not CE.lockedUI end,
			setFunc = function(newVal) CE.MoveUI() CE.lockedUI = not newVal; end,
		},
        {
			type    = "checkbox",
			name    = "Only Show in Trials/Arenas",
			tooltip = "Display will only show in trial and arena instances",
			getFunc = function() return CE.show_in_zone end,
			setFunc = function(newVal) CE.SaveShowInZone(newVal) CE.show_in_zone = newVal; end,
			warning = "Will update on next zone change!"
		},
        {
			type    = "checkbox",
			name    = "Hide in Combat",
			tooltip = "Hides display while in combat",
			getFunc = function() return CE.hideInCombat end,
			setFunc = function(newVal) CE.SaveHideInCombat(newVal) CE.hideInCombat = newVal; end,
		},  
        {
			type = "slider",
			name = "Hide In Combat Delay",
			tooltip = "Set number of seconds to wait before hiding display when combat starts",
			min = 0,
			max = 15,
			step = 1,	
			getFunc = function() return CE.hide_delay end,
			setFunc = function(value) CE.SaveHideDelay(value) CE.hide_delay = value end,
			width = "full",	
            disabled = function() return not CE.hideInCombat end
			--default = 15,	
		},      
        {
            type = "header",
            name = "Colors",
            width = "full",
        },
        {
			type = "colorpicker",
			name = "Header Color",
			tooltip = "Set the color of \"Currently Equipped\"",
			getFunc = function() return unpack(CE.head_color) end,
			setFunc = function(r,g,b,a) CE.SaveHeadColor(r, g, b, a) end,
			width = "full",
			--warning = "Color will update next time text updates",
		},
        {
			type = "colorpicker",
			name = "Completed Sets",
			tooltip = "Set the color completed sets are shown in",
			getFunc = function() return unpack(CE.comp_color) end,
			setFunc = function(r,g,b,a) CE.SaveCompColor(r, g, b, a) end,
			width = "full",
			--warning = "Color will update next time text updates",
		},
        {
			type = "colorpicker",
			name = "Incomplete Sets",
			tooltip = "Set the color incomplete sets are shown in",
			getFunc = function() return unpack(CE.incomp_color) end,
			setFunc = function(r,g,b,a) CE.SaveIncompColor(r, g, b, a) end,
			width = "full",
			--warning = "Color will update next time text updates",
		},
        {
			type = "colorpicker",
			name = "Warning Color",
			tooltip = "Set the color overcompleted and 1pc Monster sets are shown in",
			getFunc = function() return unpack(CE.warn_color) end,
			setFunc = function(r,g,b,a) CE.SaveWarnColor(r, g, b, a) end,
			width = "full",
			--warning = "Color will update next time text updates",
		},
        {
            type = "header",
            name = "Debug",
            width = "full",
        },
        {
            type = "button",
            name = "Force Update",
            tooltip = "Manually update the UI if an error occurs",
            func = function() CE.DelayUpdate() end,
            width = "full",	--or "full" (optional)
        },
    }

    LAM = LibAddonMenu2
	LAM:RegisterAddonPanel(CE.name .. "Options", menuOptions)
	LAM:RegisterOptionControls(CE.name .. "Options", dataTable)
end