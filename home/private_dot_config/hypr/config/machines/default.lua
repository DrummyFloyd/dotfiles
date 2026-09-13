--- Values shared by every machine, overridden by <hostname>.lua.

--- @type Machine
return {
  -- Catch-all: any undeclared monitor comes up at its highest resolution.
  monitors = {
    { output = "", mode = "highres", position = "auto", scale = 1 },
  },
  devices = {},
  nvidia = false,
  nvidia_backend = nil,
  drm_devices = nil,
}
