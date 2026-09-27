--- Submaps: temporary keybind modes.
--- https://wiki.hypr.land/configuring/core/binds/submaps/

local Bind = require("lib.bind")
local Notify = require("lib.notify")

local RESIZE_STEP = 10

--- Builds a submap name that doubles as the key summary waybar shows while
--- the mode is active: hyprland/submap renders Pango markup and the theme
--- colours the module, so descriptions are only dimmed with alpha.
--- @param title string
--- @param keys string[][] { key, description } pairs
--- @return string
local function mode(title, keys)
	local parts = {}
	for _, key in ipairs(keys) do
		parts[#parts + 1] = ("<b>%s</b> <span alpha='55%%'>%s</span>"):format(key[1], key[2])
	end

	return ("<b>%s</b>   %s"):format(title, table.concat(parts, "<span alpha='35%'>  ·  </span>"))
end

local RESIZE = mode("Resize", { { "H J K L", "taille" }, { "Tab", "fenêtre suivante" }, { "Esc", "quitter" } })
local WORKSPACE = mode("Workspace", { { "H", "écran ←" }, { "L", "écran →" }, { "Esc", "quitter" } })
local THEME = mode("Theme", { { "S", "style" }, { "P", "palette" }, { "W", "wallpaper" }, { "Esc", "quitter" } })

-- ########################## Submap announcement #########################
-- Replaces the submapNotif script, which kept a socat listener on socket2
-- alive just to watch for `submap>>` events.

hl.on("keybinds.submap", function(name)
	if type(name) ~= "string" then
		name = hl.get_current_submap()
	end
	-- Only the title, without the key summary and its markup.
	local title = name:match("^<b>(.-)</b>") or name
	Notify.send("Submap: " .. (title ~= "" and title or "disabled"))
end)

-- ############################ Window Resize #############################

Bind.key("ALT + R", hl.dsp.submap(RESIZE), "Resize mode")

hl.define_submap(RESIZE, function()
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

Bind.key("ALT + W", hl.dsp.submap(WORKSPACE), "Workspace move mode")

hl.define_submap(WORKSPACE, function()
	Bind.key("H", hl.dsp.workspace.move({ monitor = "-1" }), "Workspace to previous monitor")
	Bind.key("L", hl.dsp.workspace.move({ monitor = "+1" }), "Workspace to next monitor")
	Bind.key("ESCAPE", hl.dsp.submap("reset"), "Exit mode")
end)

-- ################################ Theme #################################
-- S / P / W open a rofi picker that previews live. The mode is left while rofi
-- is open (its keys would catch what is typed in rofi) and entered again once
-- rofi closes: Esc closes rofi, a second Esc leaves the mode.

--- Re-enters the theme mode; called through `hyprctl eval` once a picker closes.
function ThemeMode()
	hl.dispatch(hl.dsp.submap(THEME))
end

--- @param cmd string
--- @return fun()
local function pick_then_return(cmd)
	return function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.exec_cmd(cmd .. "; hyprctl eval 'ThemeMode()'")
	end
end

Bind.key("ALT + T", hl.dsp.submap(THEME), "Theme mode")

hl.define_submap(THEME, function()
	local scripts = require("config").scripts
	Bind.key("S", pick_then_return(scripts .. "/theme menu style"), "Pick a style")
	Bind.key("P", pick_then_return(scripts .. "/theme menu palette"), "Pick a palette")
	Bind.key("W", pick_then_return(scripts .. "/wallpaper pick"), "Pick a wallpaper")
	Bind.key("ESCAPE", hl.dsp.submap("reset"), "Exit mode")
end)
