--- Hyprland look for the galet-dark theme, loaded by hypr/config/theme.lua.
return {
	general = {
		border_size = 4,
		col = {
			-- Gradient so the looping borderangle animation shows
			active_border = { colors = { "rgba(e3a441ff)", "rgba(d9703aff)", "rgba(b9523aff)", "rgba(e3a441ff)" }, angle = 45 },
			inactive_border = "rgba(4a3f37ff)",
		},
	},
	decoration = {
		rounding = 10,
		shadow = {
			enabled = false,
		},
	},
	group = {
		col = {
			border_active = { colors = { "rgba(e3a441ff)", "rgba(d9703aff)", "rgba(b9523aff)", "rgba(e3a441ff)" }, angle = 45 },
			border_inactive = "rgba(4a3f37ff)",
		},
		groupbar = {
			col = {
				active = "rgba(e3a441ff)",
				inactive = "rgba(4a3f37ff)",
			},
		},
	},
}
