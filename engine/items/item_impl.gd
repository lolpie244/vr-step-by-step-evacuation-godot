class_name Item
extends Node

signal placed(tile: Tile)

var size: Vector2i = Vector2.ONE
var pos: Vector2

var rotation: float:
	get():
		return deg_to_rad(90 * _direction)

var _tile: Tile
var _direction: Utils.Direction = Utils.Direction.UP


func get_type() -> String:
	assert(false, "Not implemented")
	return ""


func _init(_size: Vector2 = Vector2.ONE):
	size = _size


func _is_valid_tile(tile: Tile) -> bool:
	return _tile and tile.get_mixin(ItemHolder) and tile.get_mixin(ItemHolder).can_hold_item(self)


func tiles() -> Array[Tile]:
	if !_tile:
		return []

	var result: Array[Tile] = []

	var tiles_offset: Vector2i = (size as Vector2).rotated(rotation)

	for x in tiles_offset.x:
		for y in tiles_offset.y:
			result.append(_tile.grid.get_tile(_tile.pos.x + x, _tile.pos.y + y))

	return result


func valid() -> bool:
	if !_tile:
		return false

	for tile in tiles():
		if !_is_valid_tile(_tile):
			return false
	return true


func place(tile: Tile, direction: Utils.Direction):
	if tile == _tile and direction == _direction:
		return

	var old_tile = _tile
	var old_direction = _direction
	_tile = tile
	_direction = direction

	if !valid():
		_tile = old_tile
		_direction = old_direction
		return

	for placed_tile in tiles():
		placed_tile.get_mixin(ItemHolder).place_item(self)

	placed.emit(tile)
