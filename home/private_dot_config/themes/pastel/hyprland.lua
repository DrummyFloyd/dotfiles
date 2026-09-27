--- Hyprland look for the pastel theme, loaded by hypr/config/theme.lua.
return {
	general = {
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},
	decoration = {
		rounding = 5,
		shadow = {
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},
	group = {
		col = {
			border_active = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			border_inactive = "rgba(595959aa)",
		},
		groupbar = {
			col = {
				active = "rgba(00ff0fff)",
				inactive = "rgba(f000ffbf)",
			},
		},
	},
}
