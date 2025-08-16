extends Node

class_name TileFactory

enum Type {
	None,
	Floor,
	Wall,
	Door,
	Window,
	Staircase,
}

@export var properties: Array[Tile.Flags] = []
@export var type: Type = Type.None

@export var model: MeshInstance3D
@export var substitute_model: MeshInstance3D

@export var factory_class: Script


func _get_configuration_warning():
	if not model:
		return "Model is not set"
	return ""

func get_flags():
	var flags = 0
	for property in properties:
		flags |= property

	return flags

func create(grid_: MapGrid, x_: int, y_: int):
	var result = factory_class.new()

	result.set_tile_data(grid_, x_, y_, model, get_flags())

	return result
