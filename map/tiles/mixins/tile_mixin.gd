extends Node3D

class_name TileMixin

@onready var _tile: Tile = Utils.find_parent_with_type(self, Tile)

func get_tile() -> Tile:
	return _tile
