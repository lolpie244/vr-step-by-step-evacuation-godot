class_name MapScene
extends Node3D

@onready var map: Map = $Map
@onready var scale_lever: Lever = $ScaleLever
@onready var offset_joystick: Joystick = $OffsetJoystick


func _on_zoom_lever_moved(_angle: Variant) -> void:
	map.zoom += -0.02 * scale_lever.fill_ratio


func _on_offset_joystick_moved(_angle: Vector2) -> void:
	map.offset += 0.003 * offset_joystick.fill_ratio


func _on_button_released(_button: Variant) -> void:
	GameCore.next_turn()
