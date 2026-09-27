--- Submaps: temporary keybind modes.
--- https://wiki.hypr.land/configuring/core/binds/submaps/

local Bind = require("lib.bind")
local Notify = require("lib.notify")

local RESIZE_STEP = 10

-- ########################## Submap announcement #########################
-- Replaces the submapNotif script, which kept a socat listener on socket2
-- alive just to watch for `submap>>` events.

hl.on("keybinds.submap", function(name)
	if type(name) ~= "string" then
		name = hl.get_current_submap()
	end
	Notify.send("Submap: " .. (name ~= "" and name or "disabled"))
end)

-- ############################ Window Resize #############################

Bind.key("ALT + R", hl.dsp.submap("Window Resize"), "Resize mode")

hl.define_submap("Window Resize", function()
	-- stylua: ignore start
	Bind.key({ "H", "LEFT" },  hl.dsp.window.resize({ x = -RESIZE_STEP, y = 0, relative = true }), "Narrower", { repeating = true })
	Bind.key({ "L", "RIGHT" }, hl.dsp.window.resize({ x = RESIZE_STEP,  y = 0, relative = true }), "Wider",    { repeating = true })
	Bind.key({ "K", "UP" },    hl.dsp.window.resize({ x = 0, y = -RESIZE_STEP, relative = true }), "Shorter",  { repeating = true })
	Bind.key({ "J", "DOWN" },  hl.dsp.window.resize({ x = 0, y = RESIZE_STEP,  relative = true }), "Taller",   { repeating = true })
	-- stylua: ignore end

	Bind.key("TAB", hl.dsp.window.cycle_next(), "Next window")
	Bind.key("ESCAPE", hl.dsp.submap("reset"), "Exit mode")
end)

-- ########################### Workspace Switch ###########################

Bind.key("ALT + W", hl.dsp.submap("Workspace Switch"), "Workspace move mode")

hl.define_submap("Workspace Switch", function()
	Bind.key("H", hl.dsp.workspace.move({ monitor = "-1" }), "Workspace to previous monitor")
	Bind.key("L", hl.dsp.workspace.move({ monitor = "+1" }), "Workspace to next monitor")
	Bind.key("ESCAPE", hl.dsp.submap("reset"), "Exit mode")
end)

-- ################################ Theme #################################
-- N / P cycle and stay in the mode to preview; D and M apply then exit.
-- A notification lists the themes with the active one highlighted.

local THEME = require("config").scripts .. "/theme"

--- @param cmd string
--- @return fun()
local function exec_and_exit(cmd)
	return function()
		hl.exec_cmd(cmd)
		hl.dispatch(hl.dsp.submap("reset"))
	end
end

Bind.key("ALT + T", function()
	hl.dispatch(hl.dsp.submap("Theme"))
	hl.exec_cmd(THEME .. " show")
end, "Theme mode")

hl.define_submap("Theme", function()
	Bind.cmd("N", THEME .. " next", "Next theme")
	Bind.cmd("P", THEME .. " prev", "Previous theme")
	Bind.key("D", exec_and_exit(THEME .. " default"), "Default theme")
	Bind.key("M", exec_and_exit(THEME .. " menu"), "Pick a theme")
	Bind.key("ESCAPE", hl.dsp.submap("reset"), "Exit mode")
end)
