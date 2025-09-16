extends Node3D
class_name Tile
const _implements := "TileImpl"


signal highlight_changed(value: bool)

enum Type {
	None,
	Floor,
	Wall,
	Door,
	Window,
	Staircase,
}

var _x: int
var _y: int
var grid: MapGrid
@export var type: Type = Type.None

var mixins: Array[TileMixinImpl] = []

var pos: Vector2i:
	get():
		return Vector2i(_x, _y)

var highlight: bool:
	set(val):
		if highlight == val:
			return
		highlight = val
		highlight_changed.emit(highlight)


func set_data(grid_: MapGrid, x_: int, y_: int):
	_x = x_
	_y = y_
	grid = grid_


func set_from(data: Tile):
	_x = data._x
	_y = data._y
	grid = data._grid
	mixins = data.mixins
	type = data.type


func get_mixin(impl_type):
	for mixin in mixins:
		if is_instance_of(mixin, impl_type):
			return mixin

		return null

func remove_mixin(impl_type):
	pass
	# var mixin: Node3D = get_mixin(type)
	# if mixin != null:
	# 	self.remove_child(mixin)
	# 	mixin.free()


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
