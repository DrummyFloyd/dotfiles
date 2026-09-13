--- Monitor layout and the workspace rules that go with it.
--- https://wiki.hypr.land/configuring/core/monitors/

local Machine = require("config").machine

for _, monitor in ipairs(Machine.monitors) do
	hl.monitor(monitor)
end

-- G9 (ultrawide): centered master layout.
-- https://wiki.hypr.land/configuring/core/rules/workspace-rules/
hl.workspace_rule({ workspace = "m[HDMI-A-1]", layout_opts = { orientation = "center" } })
