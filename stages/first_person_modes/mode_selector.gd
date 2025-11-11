extends Node3D

static var _modes := [FirstPersonModeExtinguisher, FirstPersonModeDoor]

var context: FirstPersonScene.Context


func _ready() -> void:
	for mode in _modes:
		if mode.is_applicable(context):
			SceneManager.replace_scene(mode.scene(), context)
