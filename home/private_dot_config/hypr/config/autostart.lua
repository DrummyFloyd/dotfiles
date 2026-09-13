--- Programs started with the session.
--- Hooked on the "hyprland.start" event from config/init.lua.
--- https://wiki.hypr.land/configuring/core/autostart/

local SCRIPTS = require("config").scripts

--- @return nil
return function()
	-- Make sure the right XDG portal is running
	hl.exec_cmd(SCRIPTS .. "/xdg-portal-hyprland")
	hl.exec_cmd("uwsm app -- waybar")
	hl.exec_cmd("uwsm app -- hyprpaper")
	hl.exec_cmd("uwsm app -- dunst")
	hl.exec_cmd("uwsm app -- udiskie -an")
	hl.exec_cmd("uwsm app -- nm-applet --indicator")
	hl.exec_cmd("uwsm app -- blueman-applet")
	hl.exec_cmd("uwsm app -- /usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("uwsm app -- /usr/bin/vesktop")
	hl.exec_cmd("uwsm app -- /usr/bin/zapzap")
	-- hl.exec_cmd("uwsm app -- /usr/bin/slack")
	-- hl.exec_cmd("uwsm app -- /usr/bin/bitwarden-desktop")
end
