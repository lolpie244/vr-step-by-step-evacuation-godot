class_name TileMixin
extends Node3D

const IMPLMENTS := "TileMixin"

var _tile: Tile


func _init(tile: Tile):
	_tile = tile


func get_tile() -> Tile:
	return _tile


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_tile.mixins.erase(self)
