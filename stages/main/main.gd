extends Node3D
const IMPLEMENTS := "MainScene"

@export var strategic_scene: PackedScene
@export var map_builder_scene: PackedScene
@export var fallback_scene: PackedScene

var _initialized := false


func _get_configuration_warning():
	if not strategic_scene or not fallback_scene:
		return "Scene's are missing"
	return ""


func _enter_scene():
	SceneManager.load_scene(strategic_scene)


func _on_xr_started() -> void:
	if _initialized:
		return
	_initialized = true
	Metrics.enabled = false
	Metrics.init()
	SceneManager.load_scene(map_builder_scene)


func _on_xr_failed_to_initialize() -> void:
	SceneManager.load_scene(fallback_scene)
