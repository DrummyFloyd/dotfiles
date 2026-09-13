--- Global options: layout, decoration, input, groups, misc.
--- https://wiki.hypr.land/configuring/core/config-options/

local Config = require("config")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 3,
		layout = "master",
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	decoration = {
		inactive_opacity = 0.95,
		rounding = 5,
		shadow = {
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			new_optimizations = true,
		},
	},

	-- Curves and animations themselves live in config/animations.lua
	animations = {
		enabled = true,
	},

	input = {
		kb_layout = "fr",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 to 1.0, 0 means no modification
		touchpad = {
			natural_scroll = true,
		},
	},

	binds = {
		allow_workspace_cycles = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		key_press_enables_dpms = true,
		animate_mouse_windowdragging = true,
		enable_swallow = false,
		allow_session_lock_restore = true,
		on_focus_under_fullscreen = 2,
	},

	group = {
		col = {
			border_active = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			border_inactive = "rgba(595959aa)",
		},
		groupbar = {
			font_family = "FiraCode Nerd Font",
			font_size = 6,
			col = {
				active = "rgba(00ff0fff)",
				inactive = "rgba(f000ffbf)",
			},
		},
	},

	-- https://wiki.hypr.land/configuring/layouts/dwindle-layout/
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	-- https://wiki.hypr.land/configuring/layouts/master-layout/
	master = {
		allow_small_split = true,
		new_on_top = false,
		mfact = 0.55,
	},

	debug = {
		disable_logs = false,
		vfr = true,
		enable_stdout_logs = true,
	},
})

-- Per-input-device settings, declared in the machine profile.
-- https://wiki.hypr.land/configuring/core/devices/
for _, device in ipairs(Config.machine.devices) do
	hl.device(device)
end
