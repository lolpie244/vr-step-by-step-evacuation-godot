class_name Item
extends RefCounted

signal placed(tile: Tile)
signal removed(item: Item)

var size: Vector2i = Vector2.ONE
var material: FlammableMaterial
var is_walkable: bool = false

var rotation: float:
	get():
		return deg_to_rad(90 * _direction)

var _tile: Tile
var _direction: Utils.Direction = Utils.Direction.UP


func get_type() -> String:
	assert(false, "Not implemented")
	return ""


func _init(_size: Vector2i = Vector2i.ONE):
	size = _size


func _is_valid_tile(tile: Tile) -> bool:
	return not tile.is_wall_like


func get_direction() -> Utils.Direction:
	return _direction


func tiles() -> Array[Tile]:
	if !_tile:
		return []

	var result: Array[Tile] = []

	var tiles_offset: Vector2i = round((size as Vector2).rotated(rotation))

	var pos := _tile.pos
	if tiles_offset.x < 0:
		pos.x += tiles_offset.x + 1
		tiles_offset.x = abs(tiles_offset.x)

	if tiles_offset.y < 0:
		pos.y += tiles_offset.y + 1
		tiles_offset.y = abs(tiles_offset.y)

	for x in range(tiles_offset.x):
		for y in range(tiles_offset.y):
			result.append(_tile.grid.get_tile(pos.x + x, pos.y + y))

	return result


func valid() -> bool:
	if !_tile:
		return false

	for tile in tiles():
		if not (
			tile
			and tile.get_mixin(ItemHolder)
			and tile.get_mixin(ItemHolder).can_hold_item(self)
			and _is_valid_tile(tile)
		):
			return false
	return true


func is_valid_placement(tile: Tile, direction: Utils.Direction) -> bool:
	if tile == _tile and direction == _direction:
		return false

	var old_tile = _tile
	var old_direction = _direction
	_tile = tile
	_direction = direction

	var result := valid()
	_tile = old_tile
	_direction = old_direction

	return result


func place(tile: Tile, direction: Utils.Direction):
	if !is_valid_placement(tile, direction):
		return false

	_tile = tile
	_direction = direction

	restore_position()


func restore_position():
	for placed_tile in tiles():
		placed_tile.get_mixin(ItemHolder).place_item(self)

	placed.emit(_tile)


func remove():
	self._tile = null
	removed.emit(self)


func main_tile() -> Tile:
	return _tile
