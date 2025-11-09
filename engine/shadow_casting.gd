class_name ShadowCasting
extends RefCounted

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}


class Quadrant:
	var direction: Direction
	var origin: Vector2i
	var grid: MapGrid

	func _init(_direction: Direction, _origin: Tile):
		self.grid = _origin.grid
		self.origin = _origin.pos

		self.direction = _direction

	func get_tile(row_tile: Pair) -> Tile:
		if row_tile == null:
			return null
		var depth = row_tile.first
		var width = row_tile.second
		match direction:
			Direction.NORTH:
				return grid.get_tile(origin.x - depth, origin.y + width)
			Direction.SOUTH:
				return grid.get_tile(origin.x + depth, origin.y + width)
			Direction.EAST:
				return grid.get_tile(origin.x + width, origin.y + depth)
			Direction.WEST:
				return grid.get_tile(origin.x + width, origin.y - depth)
		return null


class Row:
	var depth: int
	var start: float
	var end: float

	func _init(_depth: int, _start: float, _end: float):
		self.depth = _depth
		self.start = _start
		self.end = _end

	func tiles() -> Array[Pair]:
		var result: Array[Pair] = []

		var start_width = floor(depth * start + 0.5)
		var end_width = ceil(depth * end - 0.5)

		for width in range(start_width, end_width + 1):
			result.append(Pair.new(depth, width))

		return result

	func duplicate() -> Row:
		return Row.new(depth + 1, start, end)


static func _slope(tile: Pair):
	return (2.0 * tile.second - 1.0) / (2.0 * tile.first)


static func _is_symmetric(row: Row, tile: Pair):
	return (tile.second >= row.depth * row.start) and (tile.second <= row.depth * row.end)


static func visible_tiles(origin: Tile) -> Array[Tile]:
	var result: Dictionary[Tile, bool] = {}

	for direction in Direction.values():
		var quadrant := Quadrant.new(direction, origin)
		var rows := [Row.new(1, -1, 1)]

		var is_wall := func(row_tile: Pair):
			var tile = quadrant.get_tile(row_tile)
			if tile == null:
				return false
			var mixin = tile.get_mixin(Blockable)
			return mixin != null && mixin.blocking

		var is_floor := func(row_tile: Pair):
			var tile = quadrant.get_tile(row_tile)
			return tile != null && !is_wall.call(row_tile)

		while rows.size():
			var row: Row = rows.pop_front()

			var prev_tile: Pair = null

			for row_tile in row.tiles():
				var tile := quadrant.get_tile(row_tile)
				if tile == null:
					continue
				if is_wall.call(row_tile) or _is_symmetric(row, row_tile):
					result[quadrant.get_tile(row_tile)] = true

				if is_wall.call(prev_tile) && is_floor.call(row_tile):
					row.start = _slope(row_tile)

				if is_floor.call(prev_tile) && is_wall.call(row_tile):
					var next_row: Row = row.duplicate()
					next_row.end = _slope(row_tile)
					rows.append(next_row)

				prev_tile = row_tile

			if is_floor.call(prev_tile):
				rows.append(row.duplicate())

	return result.keys()
