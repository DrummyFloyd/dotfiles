--- Window rules.
--- https://wiki.hypr.land/configuring/core/rules/window-rules/

-- Ignore maximize requests, inhibit idle while fullscreen.
hl.window_rule({
  name = "suppress_maximize",
  match = { class = ".*" },
  suppress_event = "maximize",
  idle_inhibit = "fullscreen",
})

-- Red/yellow border on the fullscreen window.
hl.window_rule({
  name = "border_fullscreen",
  match = { fullscreen = true },
  border_color = { colors = { "rgb(FFFF00)", "rgb(880808)" } },
})

-- ############################### Floating ###############################

hl.window_rule({
  name = "pavucontrol",
  match = { class = "^(pavucontrol)$" },
  float = true,
})

hl.window_rule({
  name = "polkit_agent",
  match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
  float = true,
  no_screen_share = true,
})

hl.window_rule({
  name = "nm_connection_editor",
  match = { class = "^(nm-connection-editor)$" },
  float = true,
})

hl.window_rule({
  name = "nwg_look",
  match = { class = "^(nwg-look)$" },
  float = true,
  animation = "popin",
})

hl.window_rule({
  name = "blueman_manager",
  match = { class = "^(blueman-manager)$" },
  float = true,
  no_screen_share = true,
})

hl.window_rule({
  name = "pinentry_focused",
  match = { class = "^[Pp]inentry(-.*)?$" },
  stay_focused = true,
  no_screen_share = true,
})

-- ########################### Floating centered ##########################

hl.window_rule({
  name = "spf_float_center",
  match = { title = "^(spf)$" },
  float = true,
  center = true,
  size = { "(monitor_w*0.9)", "(monitor_h*0.8)" },
})

hl.window_rule({
  name = "nautilus_float_center",
  match = { class = "^(org.gnome.Nautilus)$" },
  float = true,
  center = true,
  size = { "(monitor_w*0.9)", "(monitor_h*0.8)" },
})

hl.window_rule({
  name = "update_sys_float",
  match = { class = "^(kitty)$", title = "^(update-sys)$" },
  float = true,
  tile = false,
  pseudo = false,
  center = true,
  size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
  animation = "popin",
})

-- Picture-in-Picture: parked bottom-right, aspect ratio preserved.
hl.window_rule({
  name = "pip_float",
  match = { initial_title = "Picture-in-Picture" },
  float = true,
  pin = false,
  content = "video",
  animation = "popin",
  no_initial_focus = true,
  keep_aspect_ratio = true,
  move = { "(monitor_w-window_w-30)", "(monitor_h-window_h-30)" },
  min_size = { 300, 169 },
  max_size = { 600, 338 },
})

-- ############################# Pinned apps ##############################

hl.window_rule({
  name = "slack_workspace",
  match = { class = "^(Slack)$" },
  workspace = "8 silent",
})

hl.window_rule({
  name = "discord_workspace",
  match = { class = "^(vesktop)$" },
  workspace = "9 silent",
})

hl.window_rule({
  name = "whatsapp_workspace",
  match = { class = "^(com.rtosta.zapzap)$" },
  workspace = "10 silent",
})
