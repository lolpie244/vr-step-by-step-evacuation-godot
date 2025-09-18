extends TileMixin
class_name Walkable

signal on_chacter_placed(character: Character)


func place_character(character: Character) -> bool:
	on_chacter_placed.emit(character)
	return true


class ReachableResult:
	var tile: Tile
	var distance: int
	var direction: Vector2

	func _init(_tile: Tile, _distance: int, _direction: Vector2):
		tile = _tile
		distance = _distance
		direction = _direction


func reachable_neighbors() -> Array[Walkable]:
	var result: Array[Walkable] = []

	for tile in _tile.neighbor_tiles():
		if tile.pos.x != _tile.pos.x && tile.pos.y != _tile.pos.y:
			continue

		var mixin = tile.get_mixin(Walkable)
		if mixin != null:
			result.append(mixin)

	return result


func reachable_tiles(_speed: int) -> Array[ReachableResult]:
	var result: Array[ReachableResult] = []

	var queue := [[get_tile(), _speed]]
	var used := {}

	while queue.size():
		var info = queue.pop_front()
		var current_walkable: Walkable = info[0].get_mixin(Walkable)
		var speed: int = info[1]

		if speed <= 0:
			continue

		for walkable in current_walkable.reachable_neighbors():
			var tile := walkable.get_tile()

			if used.has(tile.get_instance_id()):
				continue
			result.append(
				ReachableResult.new(
					tile, _speed - speed + 1, current_walkable.get_tile().direction_to(tile)
				)
			)

			used[tile.get_instance_id()] = true
			queue.append([tile, speed - 1])

	return result
