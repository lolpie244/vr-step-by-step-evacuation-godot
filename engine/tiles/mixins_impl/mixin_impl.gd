extends Node3D
class_name TileMixin
const _implements := "TileMixin"

var _tile: Tile

func _init(tile_: Tile):
	_tile = tile_

func get_tile() -> Tile:
	return _tile

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_tile.mixins.erase(self)
