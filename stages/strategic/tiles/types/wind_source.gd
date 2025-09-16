extends WallLikeTile

class_name WindSourceTile

var _is_open: bool = false

const WIND_STRENGHT = 10.0


func _is_outside() -> bool:
	return neighbor_tiles().size() != 8


func init():
	super.init()

	if _is_outside():
		blocking = true
		self.set_open(true)
	else:
		# TODO: wind directed inside doors

		# Inside house
		# call_deferred("set_open", true)
		pass


func set_open(state: bool):
	if _is_open == state:
		return

	_is_open = state

	var used := {self.get_instance_id(): true}
	var queue: Array = [[self, WIND_STRENGHT]]

	while queue.size():
		var info = queue.pop_front()
		var current_tile: Tile = info[0]
		var strength: int = info[1]

		if strength == 0:
			continue

		for tile in current_tile.neighbor_tiles():
			if tile.blocking || used.has(tile.get_instance_id()):
				continue

			if tile is WindSourceTile && tile._is_outside():
				continue

			var wind_strength := tile.direction_to(current_tile).normalized() * strength
			if _is_open:
				tile.wind = (tile.wind + wind_strength) / 2.0
			else:
				tile.wind = tile.wind * 2.0 - wind_strength

			used[tile.get_instance_id()] = true
			queue.append([tile, strength - 1])
