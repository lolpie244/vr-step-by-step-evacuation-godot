@tool
extends Node
class_name GridItemFactory

@export var class_type: Script
var _shared_data


func _ready() -> void:
	_shared_data = _create_shared_data()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if class_type == null:
		warnings.append("Factory class: not set")
	return warnings


func create(grid_: MapGrid, x_: int, y_: int):
	return class_type.new(_shared_data, grid_, x_, y_)


func _create_shared_data():
	assert(false, "Must be overridden")
