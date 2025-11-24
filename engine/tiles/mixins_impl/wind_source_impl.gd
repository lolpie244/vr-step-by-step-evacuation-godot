class_name WindSource
extends TileMixin

const WIND_STRENGHT = 10.0


func _is_outside() -> bool:
	return _tile.neighbor_tiles().size() != 8


func init():
	var is_open := true

	var blockable: Blockable = _tile.get_mixin(Blockable)
	if blockable:
		is_open = blockable.blocking
		blockable.blocking_changed.connect(set_open)

	self.set_open(is_open)


func _set_wind(mixin: RefCounted, wind_strength: Vector2, state: bool):
	if !mixin:
		return
	if state:
		mixin.wind = (mixin.wind + wind_strength) / 2.0
	else:
		mixin.wind = mixin.wind * 2.0 - wind_strength


func set_open(state: bool):
	var used := {_tile.get_instance_id(): true}
	var queue: Array = [Pair.new(_tile, WIND_STRENGHT)]

	while queue.size():
		var info = queue.pop_front()
		var current_tile: Tile = info.first
		var strength: int = info.second

		if strength == 0:
			continue

		for tile in current_tile.neighbor_tiles():
			if (
				(tile.get_mixin(Blockable) && tile.get_mixin(Blockable).blocking)
				|| used.has(tile.get_instance_id())
			):
				continue

			if tile.get_mixin(WindSource) && tile.get_mixin(WindSource)._is_outside():
				continue

			var wind_strength := tile.direction_to(current_tile).normalized() * strength
			_set_wind(tile.get_mixin(Flammable), wind_strength, state)
			_set_wind(tile.get_mixin(Smokable), wind_strength, state)

			used[tile.get_instance_id()] = true
			queue.append(Pair.new(tile, strength - 1))
