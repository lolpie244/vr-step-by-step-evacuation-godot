class_name TileMixin
extends Node3D

const IMPLEMENTS := "TileMixin"

var _tile: Tile


func _init(tile: Tile):
	_tile = tile


func get_tile() -> Tile:
	return _tile


func init():
	pass


func process_turn(_turn_number: int):
	pass


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_tile.mixins.erase(self)
