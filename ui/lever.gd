extends Node3D
class_name Lever

@export var emit_only_angle_change: bool = false

signal hinge_moved(current_angle)
signal released


@onready var properties: XRToolsInteractableHinge = $Lever/lever

var fill_ratio: float:
	get():
		return Utils.signed_ratio(
			properties.hinge_limit_min,
			properties.hinge_limit_max,
			properties.hinge_position
		)


var _is_picked_up: bool = false
var _last_angle: float = 0

func _process(_delta: float) -> void:
	if !_is_picked_up:
		return

	if emit_only_angle_change && properties.hinge_position == _last_angle:
		return

	_last_angle = properties.hinge_position
	emit_signal("hinge_moved", properties.hinge_position)


func _on_lever_released(_interactable: Variant) -> void:
	_is_picked_up = false
	emit_signal("released")


func _on_lever_grabbed(_interactable: Variant) -> void:
	_last_angle = 0
	_is_picked_up = true
pass # Replace with function body.
