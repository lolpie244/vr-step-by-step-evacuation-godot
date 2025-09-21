extends Node3D

@export var strategic_scene: PackedScene
@export var fallback_scene: PackedScene

var xr_interface: XRInterface


func _get_configuration_warning():
	if not strategic_scene or not fallback_scene:
		return "Scene's are missing"
	return ""


func _set_action_set_priorities():
	const PRIORITIES = {"godot": 0, "strategic": 1}

	var action_map: OpenXRActionMap = load("res://openxr_action_map.tres")

	for action_set: OpenXRActionSet in action_map.action_sets:
		action_set.priority = PRIORITIES[action_set.resource_name]

	ResourceSaver.save(action_map, "res://openxr_action_map.tres")


func _ready():
	_set_action_set_priorities()

	xr_interface = XRServer.find_interface("OpenXR")

	if not xr_interface or not xr_interface.is_initialized():
		print("OpenXR is not initialized. Use fallback_scene")

		SceneManager.load_scene(fallback_scene)
		return

	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_viewport().use_xr = true

	print("OpenXR is initialized")

	SceneManager.load_scene(strategic_scene)
