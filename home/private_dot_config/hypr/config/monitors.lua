--- Monitor layout and the per-monitor workspace rules that go with it.
--- https://wiki.hypr.land/configuring/core/monitors/
--- https://wiki.hypr.land/configuring/core/rules/workspace-rules/

local Machine = require("config").machine

--- Profile keys describing the workspace rule rather than the monitor itself.
local RULE_KEYS = { layout = true, layout_opts = true }

--- Splits a profile entry into an hl.monitor() spec and its workspace rule fields.
--- @param entry table
--- @return HL.MonitorSpec spec, table|nil rule
local function split(entry)
	local spec, rule = {}, nil
	for key, value in pairs(entry) do
		if RULE_KEYS[key] then
			rule = rule or {}
			rule[key] = value
		else
			spec[key] = value
		end
	end

	return spec, rule
end

--- Resolves a profile `output` to the name of a connected monitor.
--- The m[…] workspace selector wants a name while the profile may address a
--- monitor by description, so the live list bridges the two. Descriptions match
--- on a prefix, the way Hyprland's own `desc:` selector does.
--- @param output string
--- @return string|nil
local function monitor_name(output)
	local description = output:match("^desc:(.+)$")
	for _, monitor in ipairs(hl.get_monitors()) do
		if description then
			if monitor.description and monitor.description:sub(1, #description) == description then return monitor.name end
		elseif monitor.name == output then
			return monitor.name
		end
	end
end

--- Binds each declared layout to that monitor's workspaces.
--- A workspace keeps the layout it was given when it was created, so one that
--- migrates to another screen (hotplug, a monitor disabled by mainMonitorSwitch,
--- a manual move) drags the old layout along. Registering the rule again makes
--- Hyprland re-evaluate every workspace currently sitting on that monitor, which
--- is what puts the migrated ones back on the right layout.
--- A monitor declared without a layout gets general.layout spelled out, so that
--- fallback holds after a migration instead of only at creation time.
--- Only a currently connected monitor can be named in a rule.
local function apply_rules()
	local fallback = hl.get_config("general.layout")

	for _, entry in ipairs(Machine.monitors) do
		local spec, rule = split(entry)

		if spec.output ~= "" then
			local name = monitor_name(spec.output)
			if name then
				hl.workspace_rule({
					workspace = "m[" .. name .. "]",
					layout = rule and rule.layout or fallback,
					layout_opts = rule and rule.layout_opts,
				})
			end
		end
	end
end

--- Applies every monitor spec, then the workspace rules that go with them.
--- Replayed on hotplug.
local function apply()
	for _, entry in ipairs(Machine.monitors) do
		hl.monitor((split(entry)))
	end

	apply_rules()
end

apply()
hl.on("monitor.added", apply)
--- Only the rules are replayed here: re-applying the monitor specs would undo a
--- monitor that mainMonitorSwitch just disabled.
hl.on("monitor.removed", apply_rules)
hl.on("workspace.move_to_monitor", apply_rules)
