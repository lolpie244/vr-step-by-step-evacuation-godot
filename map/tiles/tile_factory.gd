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

@export var factory_class: Script

var _shared_data: SharedData


func _ready() -> void:
	_shared_data = SharedData.new(self)


func _get_configuration_warning():
	if not factory_class:
		return "Factory class is not set"
	return ""


func get_flags():
	var flags = 0
	for property in properties:
		flags |= property

	return flags


func create(grid_: MapGrid, x_: int, y_: int):
	return factory_class.new(_shared_data, grid_, x_, y_)


class SharedData:
	var flags: int
	var model: Node3D
	var character_point: CharacterPoint

	func _init(fabric) -> void:
		flags = fabric.get_flags()
		model = fabric.get_node("model")
		character_point = fabric.get_node("character_point")
