--- Hostname-based hardware profile loading.
---
--- `default.lua` holds the shared values; `<hostname>.lua`, when present,
--- overrides them. Adding a machine means dropping a file in here, nothing else.

local Machines = {}

--- Short hostname ($HOSTNAME, falling back to /etc/hostname), nil if unusable.
--- @return string|nil
local function hostname()
	local name = os.getenv("HOSTNAME")
	if not name or name == "" then
		local file = io.open("/etc/hostname", "r")
		if not file then
			return nil
		end
		name = file:read("*l")
		file:close()
	end
	if not name then
		return nil
	end

	name = name:match("^%s*([^.%s]+)")
	if not name or not name:match("^[%w_-]+$") then
		return nil
	end

	return name
end

--- @class Machine
--- @field monitors HL.MonitorSpec[] Monitors, in order; output = "" is the catch-all rule
--- @field devices HL.DeviceSpec[] Per-input-device settings
--- @field nvidia boolean Apply the NVIDIA environment variables
--- @field nvidia_backend string|nil GBM backend: "nvidia-drm" (default) or "nvidia-open"
--- @field drm_devices string|nil WLR_DRM_DEVICES value, nil leaves it unset

--- Profile for the current machine: default.lua overridden by <hostname>.lua.
--- @return Machine
function Machines.load()
	local profile = require("config.machines.default")
	local name = hostname()
	local module = name and ("config.machines." .. name)

	if module and package.searchpath(module, package.path) then
		for key, value in pairs(require(module)) do
			profile[key] = value
		end
	end

	return profile
end

return Machines
