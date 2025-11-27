extends Node3D
const IMPLEMENTS := "FirstPersonModeSelector"

static var _modes := [
	FirstPersonModeExtinguisher, FirstPersonModeDoor, FirstPersonModeFireAlarm, FirstPersonScene
]

var context: FirstPersonScene.Context


func _ready() -> void:
	for mode in _modes:
		if mode.is_applicable(context):
			SceneManager.replace_scene(mode.scene(), context)
			break
