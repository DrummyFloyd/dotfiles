--- Hyprland look for the galet style, loaded by hypr/config/theme.lua; colours from the palette.
return {
	general = {
		border_size = 4,
		col = {
			-- Gradient so the looping borderangle animation shows
			active_border = { colors = { "rgba({{palette.accent | replace: "#", ""}}ff)", "rgba({{palette.accent2 | replace: "#", ""}}ff)", "rgba({{palette.accent3 | replace: "#", ""}}ff)", "rgba({{palette.accent | replace: "#", ""}}ff)" }, angle = 45 },
			inactive_border = "rgba({{palette.outline | replace: "#", ""}}ff)",
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
			border_active = { colors = { "rgba({{palette.accent | replace: "#", ""}}ff)", "rgba({{palette.accent2 | replace: "#", ""}}ff)", "rgba({{palette.accent3 | replace: "#", ""}}ff)", "rgba({{palette.accent | replace: "#", ""}}ff)" }, angle = 45 },
			border_inactive = "rgba({{palette.outline | replace: "#", ""}}ff)",
		},
		groupbar = {
			col = {
				active = "rgba({{palette.accent | replace: "#", ""}}ff)",
				inactive = "rgba({{palette.outline | replace: "#", ""}}ff)",
			},
		},
	},
}
