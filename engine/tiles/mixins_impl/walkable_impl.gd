class_name Walkable
extends TileMixin

signal on_chacter_placed(character: Character)

var enabled: bool = true


func init():
	var flammable: Flammable = _tile.get_mixin(Flammable)
	if flammable:
		flammable.state_changed.connect(_on_flammable_state_changed)
		_on_flammable_state_changed(flammable.state)


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
		direction = Vector2(_direction.y, _direction.x)


func reachable_neighbors() -> Array[Walkable]:
	var result: Array[Walkable] = []

	for tile in _tile.neighbor_tiles():
		if tile.pos.x != _tile.pos.x && tile.pos.y != _tile.pos.y:
			continue

		if is_walkable(tile):
			result.append(tile.get_mixin(Walkable))

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


static func is_walkable(tile: Tile):
	if !tile:
		return false
	var mixin = tile.get_mixin(Walkable)
	var blockable = tile.get_mixin(Blockable)
	var item_holder = tile.get_mixin(ItemHolder)
	return (
		mixin != null
		&& (!blockable || !blockable.blocking)
		&& (!item_holder || !item_holder.get_item())
	)


func _on_flammable_state_changed(state: Flammable.State):
	enabled = (state == Flammable.State.NOT_BURNING)
