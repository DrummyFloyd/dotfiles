--- notify-send wrapper, kept consistent with the volumeCtrl / brightnessCtrl scripts
--- (dunst styling and the icons in ~/.config/icons).
---
--- Notifications are spawned through hl.exec_cmd rather than Hyprland's native
--- hl.notification.create: exec_cmd runs the command outside the compositor event
--- loop, and a bind or event callback must never block.
--- https://wiki.hypr.land/configuring/core/binds/

local ICONS = os.getenv("HOME") .. "/.config/icons"
local DEFAULT_ICON = "hyprland.png"
--- Synchronous tag: a new notification replaces the previous one carrying the same tag.
local DEFAULT_TAG = "hyprland"

local Notify = {}

--- Wraps a value in single quotes, escaping any it contains.
--- @param value string
--- @return string
local function quote(value) return "'" .. value:gsub("'", [['\'']]) .. "'" end

--- Sends a low-urgency notification.
--- @param text string
--- @param icon string|nil File name inside ~/.config/icons
--- @param tag string|nil Synchronous tag
function Notify.send(text, icon, tag)
  hl.exec_cmd(table.concat({
    "notify-send -u low",
    "-i " .. quote(ICONS .. "/" .. (icon or DEFAULT_ICON)),
    "-h " .. quote("string:x-canonical-private-synchronous:" .. (tag or DEFAULT_TAG)),
    quote(text),
  }, " "))
end

return Notify
