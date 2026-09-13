--- Shared values and configuration loading.

local Machines = require("config.machines")

local Config = {}

--- Main modifier for keybinds.
Config.leader = "SUPER"

--- Utility scripts directory (former $scriptsDir).
Config.scripts = os.getenv("HOME") .. "/.local/bin/scripts"

--- Hardware profile for the current machine: monitors, devices, nvidia.
Config.machine = Machines.load()

--- Loads every configuration module. Called once from hyprland.lua.
function Config.setup()
	require("config.env")
	require("config.general")
	require("config.animations")
	require("config.monitors")
	require("config.rules")
	require("keymaps")
	hl.on("hyprland.start", require("config.autostart"))
end

return Config
