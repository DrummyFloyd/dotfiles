--- Global keybinds.
--- https://wiki.hypr.land/configuring/core/binds/
--- Number keys are bound by keycode (code:10 to code:19): on an AZERTY layout
--- the top row digits require SHIFT.

local Bind = require("lib.bind")
local Config = require("config")

local SCRIPTS = Config.scripts

-- ############################### Behaviour ##############################

Bind.leader_key("C", hl.dsp.window.close(), "Close window")
Bind.leader_key("V", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
Bind.leader_key("F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }), "Maximize")
Bind.leader_key("SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }), "Fullscreen")

Bind.leader_cmd("L", "uwsm app -- hyprlock", "Lock screen")
Bind.leader_cmd("SHIFT + R", SCRIPTS .. "/reloadHyprland", "Reload Hyprland")
Bind.leader_cmd("P", SCRIPTS .. "/mainMonitorSwitch", "Switch main monitor")

-- ############################# Applications #############################

Bind.leader_cmd("Return", "uwsm app -- kitty", "Terminal")
Bind.leader_cmd("E", "uwsm app -- nautilus", "File manager")
Bind.leader_cmd("A", "uwsm app -- zen-browser || uwsm app -- firefox", "Browser")
Bind.leader_cmd(
	"SHIFT + A",
	"uwsm app -- zen-browser --private-window || uwsm app -- firefox --private-window",
	"Browser (private window)"
)
Bind.leader_cmd("D", "uwsm app -- $(wofi --show drun --define=drun-print_desktop_file=true)", "App launcher")
Bind.leader_cmd("M", "wlogout --protocol layer-shell -b 2", "Logout menu")

-- ############################## Window focus ############################

Bind.leader_key("Tab", hl.dsp.window.cycle_next(), "Next window", { repeating = true })
Bind.leader_key("SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), "Previous window", { repeating = true })

-- Master layout (handy on a widescreen)
Bind.leader_key("J", hl.dsp.layout("cyclenext"), "Master: next")
Bind.leader_key("K", hl.dsp.layout("cycleprev"), "Master: previous")
Bind.leader_key("Z", hl.dsp.layout("focusmaster"), "Master: focus")
Bind.leader_key("SHIFT + Z", hl.dsp.layout("swapwithmaster"), "Master: swap")

-- ########################### Window movement ############################

-- stylua: ignore start
Bind.leader_key({ "SHIFT + H", "LEFT" },  hl.dsp.window.move({ direction = "l" }), "Move window left")
Bind.leader_key({ "SHIFT + L", "RIGHT" }, hl.dsp.window.move({ direction = "r" }), "Move window right")
Bind.leader_key({ "SHIFT + K", "UP" },    hl.dsp.window.move({ direction = "u" }), "Move window up")
Bind.leader_key({ "SHIFT + J", "DOWN" },  hl.dsp.window.move({ direction = "d" }), "Move window down")
-- stylua: ignore end

-- Move / resize with the mouse
Bind.leader_key("mouse:272", hl.dsp.window.drag(), "Drag window", { mouse = true })
Bind.leader_key("mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })

-- ############################## Workspaces ##############################

-- Back to the previous workspace (ESC, and the laptop's ² key)
Bind.leader_key({ "ESCAPE", "code:49" }, hl.dsp.focus({ workspace = "previous" }), "Previous workspace")

-- Workspaces 1 to 10 on the number row (keycodes 10 to 19)
for i = 1, 10 do
	local key = "code:" .. (i + 9)
	Bind.leader_key(key, hl.dsp.focus({ workspace = i }), "Go to workspace " .. i)
	Bind.leader_key("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move to workspace " .. i)
end

-- Scroll through workspaces
Bind.leader_key("mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
Bind.leader_key("mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")

-- ################################ Media #################################

-- stylua: ignore start
Bind.cmd("XF86AudioMicMute",      SCRIPTS .. "/volumeCtrl --toggle-mic", "Mute mic")
Bind.cmd("XF86AudioMute",         SCRIPTS .. "/volumeCtrl --toggle",     "Mute")
Bind.cmd("XF86AudioRaiseVolume",  SCRIPTS .. "/volumeCtrl --inc",        "Volume up",     { repeating = true })
Bind.cmd("XF86AudioLowerVolume",  SCRIPTS .. "/volumeCtrl --dec",        "Volume down",   { repeating = true })
Bind.cmd("XF86MonBrightnessUp",   SCRIPTS .. "/brightnessCtrl --inc",    "Brightness up",   { repeating = true })
Bind.cmd("XF86MonBrightnessDown", SCRIPTS .. "/brightnessCtrl --dec",    "Brightness down", { repeating = true })
-- stylua: ignore end

-- Audio sink/source picker (F1 on the desktop keyboard)
Bind.leader_cmd({ "XF86AudioMute", "F1" }, SCRIPTS .. "/selectSinkSource", "Pick audio sink/source")

-- ############################## Screenshots #############################

Bind.cmd("code:107", 'grim -g "$(slurp)"', "Screenshot a region")
Bind.leader_cmd("SHIFT + S", 'grim -g "$(slurp -d)" - | wl-copy', "Screenshot to clipboard")

-- ############################## Laptop lid ##############################
-- https://wiki.hypr.land/configuring/core/binds/switches/
-- The switch turning "on" means the lid is closed.
-- The panel is toggled through hl.monitor() rather than `hyprctl keyword`,
-- which no longer works with a Lua config ("keyword can't work with
-- non-legacy parsers. Use eval.").

--- @param disabled boolean
--- @return fun()
local function internal_panel(disabled)
	return function()
		hl.monitor({ output = "eDP-1", mode = "highres", position = "auto", scale = 1, disabled = disabled })
	end
end

-- stylua: ignore start
Bind.cmd("switch:on:Lid Switch",  "uwsm app -- hyprlock", "Lid closed: lock", { locked = true })
Bind.key("switch:on:Lid Switch",  internal_panel(true),   "Lid closed: disable eDP-1", { locked = true })
Bind.key("switch:off:Lid Switch", internal_panel(false),  "Lid opened: enable eDP-1",  { locked = true })
-- stylua: ignore end
