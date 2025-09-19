extends Node3D

@export var next_scene: PackedScene

var character

@onready var map: Map = $Map
@onready var scale_lever: Lever = $ScaleLever
@onready var offset_joystick: Joystick = $OffsetJoystick


func _ready() -> void:
	character = map.add_character(Character.Type.CIVILIAN, 6, 4)
	GameCore.grid.get_tile_mixin(9, 1, Flammable).ignite()
	GameCore.grid.get_tile_mixin(9, 2, Flammable).ignite()


func _on_zoom_lever_moved(_angle: Variant) -> void:
	map.zoom += -0.02 * scale_lever.fill_ratio


func _on_offset_joystick_moved(_angle: Vector2) -> void:
	map.offset += 0.003 * offset_joystick.fill_ratio


func _on_button_released(_button: Variant) -> void:
	#await $PlayerVr.close_eyes()
	var context := FirstPerson.Context.new(character.impl)
	SceneManager.load_scene(next_scene, context)
