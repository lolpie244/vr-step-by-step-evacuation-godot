class_name Dial
extends Node3D

signal value_changed(value: float)

@export var min_value: float = 0.0
@export var max_value: float = 1.0
@export var default: float = 0.5

@export var step: float = 0.1

@onready var value: float = default:
	set(val):
		val = clamp(val, min_value, max_value)
		if value == val:
			return
		value = val
		value_changed.emit(value)


func _on_minus_released(_button: Variant) -> void:
	value -= step


func _on_plus_released(_button: Variant) -> void:
	value += step
