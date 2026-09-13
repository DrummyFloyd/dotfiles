--- Session environment variables, driven by the machine profile.
--- https://wiki.hypr.land/configuring/core/environment-variables/

local Machine = require("config").machine

if Machine.drm_devices then
	hl.env("WLR_DRM_DEVICES", Machine.drm_devices)
end

-- https://wiki.hypr.land/nvidia/
if Machine.nvidia then
	hl.env("GBM_BACKEND", Machine.nvidia_backend or "nvidia-drm")
	hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
	hl.env("LIBVA_DRIVER_NAME", "nvidia")
	hl.env("__GL_GSYNC_ALLOWED", "1")
	hl.env("__GL_VRR_ALLOWED", "0")
end
