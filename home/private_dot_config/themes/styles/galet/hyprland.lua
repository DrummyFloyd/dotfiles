--- Hyprland look for the galet style, loaded by hypr/config/theme.lua; colours from the palette.

local accent = "rgba({{palette.accent | replace: "#", ""}}ff)"
local accent2 = "rgba({{palette.accent2 | replace: "#", ""}}ff)"
local accent3 = "rgba({{palette.accent3 | replace: "#", ""}}ff)"
local outline = "rgba({{palette.outline | replace: "#", ""}}ff)"

-- Gradient so the looping borderangle animation shows
local active_border = { colors = { accent, accent2, accent3, accent }, angle = 45 }

return {
	general = {
		border_size = 4,
		col = {
			active_border = active_border,
			inactive_border = outline,
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
			border_active = active_border,
			border_inactive = outline,
		},
		groupbar = {
			col = {
				active = accent,
				inactive = outline,
			},
		},
	},
}
