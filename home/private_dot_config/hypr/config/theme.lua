--- Look of the active theme: colours, rounding, shadow.
--- ~/.config/themes/current/hyprland.lua returns a table in hl.config() format;
--- switch themes with ~/.local/bin/scripts/theme.
---
--- The theme script re-runs this file through `hyprctl eval` instead of a full
--- `hyprctl reload`: a reload re-applies the whole config (re-enabling monitors
--- turned off at runtime) and Hyprland 0.56 crashes when a monitor is then
--- disabled. DEFAULTS resets what a theme may change, so switching themes
--- never keeps the previous theme's values.

local THEME = os.getenv("HOME") .. "/.config/themes/current/hyprland.lua"

local DEFAULTS = {
	general = {
		border_size = 3,
	},
	decoration = {
		rounding = 0,
		shadow = {
			enabled = true,
		},
	},
}

hl.config(DEFAULTS)

local chunk = loadfile(THEME)
if chunk then
	hl.config(chunk())
end
