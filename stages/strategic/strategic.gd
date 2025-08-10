extends Node3D

var xr_interface: XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")

	if not xr_interface or not xr_interface.is_initialized():
		print("OpenXR is not initialized")
		return


	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_viewport().use_xr = true

	print("OpenXR is initialized")
