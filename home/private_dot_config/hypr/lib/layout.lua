--- Layout switching, formerly the switchLayout script.
--- Both the read and the write are native hl calls, so no subprocess and no
--- hyprctl round-trip is involved.

local Notify = require("lib.notify")

local Layout = {}

--- @param value string
--- @return string
local function capitalize(value)
	return value:sub(1, 1):upper() .. value:sub(2)
end

--- Toggles general:layout between master and dwindle.
function Layout.toggle()
	local next_layout = hl.get_config("general:layout") == "master" and "dwindle" or "master"

	hl.config({ general = { layout = next_layout } })
	Notify.send("Layout: " .. capitalize(next_layout))
end

return Layout
