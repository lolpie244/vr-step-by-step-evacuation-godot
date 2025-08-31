extends Node

const x: float = 1.0 / 8.0

func can_burn(tile: Tile) -> bool:
	return !tile.has_flag(Tile.Flags.BURNING) && !tile.has_flag(Tile.Flags.BURNED) && !tile.material.flammable

func _fixed_prob(from: TileMaterial, to: TileMaterial) -> float:
	var release_rate := x * from.heat_release_rate * (1.0 - from.carbon_monoxide_yield) * 1000 * Constants.time_per_turn
	var flammable_rate := to.heat_capacity * (to.ignition_temp - Constants.room_temperature)

	return 1 - exp(-release_rate / flammable_rate)

func is_spread(from: Tile, to: Tile, _direction: Array[int]) -> bool:
	var fixed_prob = _fixed_prob(from.material, to.material)
	if fixed_prob != 0:
		print(fixed_prob)
	return randf_range(0, 1) < fixed_prob
