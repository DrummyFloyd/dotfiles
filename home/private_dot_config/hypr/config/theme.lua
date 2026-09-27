--- Look of the active theme: colours, rounding, shadow.
--- ~/.config/themes/current/hyprland.lua returns a table in hl.config() format;
--- switch themes with ~/.local/bin/scripts/theme.

local THEME = os.getenv("HOME") .. "/.config/themes/current/hyprland.lua"

local chunk = loadfile(THEME)
if chunk then
	hl.config(chunk())
end
