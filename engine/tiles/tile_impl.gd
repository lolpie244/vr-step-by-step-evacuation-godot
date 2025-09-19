class_name Tile

signal highlight_changed(value: bool)

enum Type {
	NONE,
	FLOOR,
	WALL,
	DOOR,
	WINDOW,
	STAIRCASE,
}

const IMPLMENTS := "Tile"

var grid: MapGrid
var type: Type = Type.NONE
var mixins: Array[TileMixin] = []

var pos: Vector2i:
	get():
		return Vector2i(_x, _y)

var highlight: bool:
	set(val):
		if highlight == val:
			return
		highlight = val
		highlight_changed.emit(highlight)

var _x: int
var _y: int
var _initialized: bool = false


func _init(_type: Type, _grid: MapGrid, x: int, y: int):
	type = _type
	_x = x
	_y = y
	grid = _grid


func init():
	if _initialized:
		return

	for mixin in mixins:
		mixin.init()

	_initialized = true


func get_mixin(mixin_type):
	for mixin in mixins:
		if is_instance_of(mixin, mixin_type):
			return mixin

	return null


func get_or_create_mixin(mixin_type):
	var mixin = get_mixin(mixin_type)
	if mixin == null:
		mixin = mixin_type.new(self)
		mixins.append(mixin)

	return mixin


func remove_mixin(mixin_type):
	var mixin = get_mixin(mixin_type)
	if mixin != null:
		mixins.erase(mixin)


func direction_to(to: Tile) -> Vector2:
	return Vector2(to.pos.x - pos.x, to.pos.y - pos.y)


func neighbor_tiles() -> Array[Tile]:
	var result: Array[Tile] = []

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 && j == 0:
				continue

			var tile: Tile = grid.get_tile(_x + i, _y + j)
			if tile != null:
				result.append(tile)
	return result


func process_turn(_turn_number: int):
	for mixin in mixins:
		mixin.process_turn(_turn_number)
