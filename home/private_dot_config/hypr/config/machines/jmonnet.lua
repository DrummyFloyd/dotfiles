--- Laptop: internal eDP-1, G9 at home, AOC at the office.
--- Monitors are declared in order; the last entry (output = "") covers any
--- unknown display hotplugged in.
---
--- `layout` and `layout_opts` are not monitor settings: config/monitors.lua
--- turns them into a workspace rule scoped to that monitor. A monitor without
--- them falls back to general.layout from config/general.lua.

--- @type Machine
return {
	monitors = {
		-- Home: Samsung Odyssey G9 (ultrawide), master on the left and slaves stacked right
		{
			output = "desc:Samsung Electric Company Odyssey G93SC HNTW900406",
			mode = "5120x1440",
			position = "auto-right",
			scale = 1,
			layout = "master",
			layout_opts = { orientation = "left" },
		},
		-- Office: AOC Q27P1B
		{
			output = "desc:AOC Q27P1B GNXM5HA210798",
			mode = "highres",
			position = "auto-up",
			scale = 1,
		},
		-- Internal panel
		{
			output = "eDP-1",
			mode = "highres",
			position = "0x0",
			scale = 1,
			layout = "dwindle",
		},
		-- Default for any new display
		{ output = "", mode = "highres", position = "auto", scale = 1 },
	},

	devices = {
		{ name = "logitech-gaming-mouse-g402-keyboard", sensitivity = -0.4 },
		{ name = "synps/2-synaptics-touchpad", sensitivity = 0 },
	},

	nvidia = false,
}
