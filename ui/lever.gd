class_name Lever
extends Node3D

signal hinge_moved(current_angle)
signal released

@export var emit_only_angle_change: bool = false

var fill_ratio: float:
	get():
		return Utils.signed_ratio(
			properties.hinge_limit_min, properties.hinge_limit_max, properties.hinge_position
		)

var _is_picked_up: bool = false
var _last_angle: float = 0

@onready var properties: XRToolsInteractableHinge = $Lever/lever


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
