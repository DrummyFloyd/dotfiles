--- Helpers around hl.bind(): automatic leader prefix and exec_cmd shorthands.
--- https://wiki.hypr.land/configuring/core/binds/

local Config = require("config")

local Bind = {}

--- @param keys string|string[]
--- @return string[]
local function as_list(keys)
	if type(keys) == "table" then
		return keys
	end

	return { keys }
end

--- @param desc string|nil
--- @param opts HL.BindOptions|nil
--- @return HL.BindOptions
local function with_desc(desc, opts)
	local merged = {}
	for key, value in pairs(opts or {}) do
		merged[key] = value
	end
	if desc then
		merged.description = desc
	end

	return merged
end

--- Bind one or more keys to a single action.
--- @param keys string|string[] e.g. "SUPER + F" or { "SUPER + H", "SUPER + LEFT" }
--- @param action HL.Dispatcher|function
--- @param desc string|nil
--- @param opts HL.BindOptions|nil
function Bind.key(keys, action, desc, opts)
	for _, key in ipairs(as_list(keys)) do
		hl.bind(key, action, with_desc(desc, opts))
	end
end

--- Like Bind.key, prefixing every key with the leader.
--- @param keys string|string[]
--- @param action HL.Dispatcher|function
--- @param desc string|nil
--- @param opts HL.BindOptions|nil
function Bind.leader_key(keys, action, desc, opts)
	local prefixed = {}
	for _, key in ipairs(as_list(keys)) do
		prefixed[#prefixed + 1] = Config.leader .. " + " .. key
	end
	Bind.key(prefixed, action, desc, opts)
end

--- Bind one or more keys to a shell command.
--- @param keys string|string[]
--- @param cmd string
--- @param desc string|nil
--- @param opts HL.BindOptions|nil
function Bind.cmd(keys, cmd, desc, opts)
	Bind.key(keys, hl.dsp.exec_cmd(cmd), desc, opts)
end

--- Like Bind.cmd, prefixing every key with the leader.
--- @param keys string|string[]
--- @param cmd string
--- @param desc string|nil
--- @param opts HL.BindOptions|nil
function Bind.leader_cmd(keys, cmd, desc, opts)
	Bind.leader_key(keys, hl.dsp.exec_cmd(cmd), desc, opts)
end

return Bind
