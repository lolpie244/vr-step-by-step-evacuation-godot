extends Node3D
class_name Joystick

@export var emit_only_angle_change: bool = false

signal moved(angle: Vector2)
signal released

@onready var properties: XRToolsInteractableJoystick = $Joystick/body

var fill_ratio: Vector2:
	get():
		return Vector2(
			Utils.signed_ratio(
				properties.joystick_x_limit_min,
				properties.joystick_x_limit_max,
				properties.joystick_x_position
			),
			Utils.signed_ratio(
				properties.joystick_y_limit_min,
				properties.joystick_y_limit_max,
				properties.joystick_y_position
			)
		)

var _is_picked_up: bool = false
var _last_angle: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	if !_is_picked_up:
		return

	var angle_ := Vector2(properties.joystick_x_position, properties.joystick_y_position)

	if emit_only_angle_change && angle_ == _last_angle:
		return

	_last_angle = angle_
	emit_signal("moved", angle_)


func _on_lever_released(_interactable: Variant) -> void:
	_is_picked_up = false
	emit_signal("released")


func _on_lever_grabbed(_interactable: Variant) -> void:
	_last_angle = Vector2.ZERO
	_is_picked_up = true
