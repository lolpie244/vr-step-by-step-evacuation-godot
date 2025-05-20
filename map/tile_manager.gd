extends Node

var tiles: Dictionary[Tile.Type, Array]


func _ready():
	for tile: Tile in self.get_children():
		if not tiles.has(tile.type):
			tiles.set(tile.type, [tile])
		else:
			tiles[tile.type].append(tile)


func get_tile(type: Tile.Type) -> Tile:
	return tiles[type][0]
