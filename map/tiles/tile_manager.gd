extends Node3D

var tiles: Dictionary[TileFactory.Type, Array]


func _ready():
	for tile: TileFactory in self.get_children():
		if not tiles.has(tile.type):
			tiles.set(tile.type, [tile])
		else:
			tiles[tile.type].append(tile)


func get_tile_factory(type: TileFactory.Type) -> TileFactory:
	return tiles[type][0]
