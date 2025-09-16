extends Node3D
class_name TileFactory

@export var tile_types: Array[PackedScene] = []

var _tiles: Dictionary[Tile.Type, Array] = {}

func _ready():
	hide()
	
	for tile_scene in tile_types:
		var tile = tile_scene.instantiate()
		self.add_child(tile)
		var impl = tile.get_node("Impl")
		var type = tile.get_node("Impl").get("type")

		if not _tiles.has(type):
			_tiles.set(type, [tile])
		else:
			_tiles[type].append(tile)
	position = Vector3.INF


func create(type, grid_, x_, y_):
	var result = _tiles[type][0].duplicate(Utils.DEFAULT_DUPLICATE)
	result.get_node("Impl").set_data(grid_, x_, y_)

	return result
