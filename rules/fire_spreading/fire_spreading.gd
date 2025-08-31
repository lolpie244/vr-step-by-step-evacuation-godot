extends Node

const x: float = 1.0 / 8.0

func can_burn(tile: Tile) -> bool:
	return !tile.has_flag(Tile.Flags.BURNING) && !tile.has_flag(Tile.Flags.BURNED) && tile.material.flammable

func _fixed_prob(from: TileMaterial, to: TileMaterial) -> float:
	var deltaT = (to.ignition_temp - Constants.room_temperature)
	var HRR = 0.345 * from.heat_release_rate * 1000
	var release_rate = pow(deltaT / HRR, 2)
	var flammable_rate = to.density * to.thermal_conductivity * to.heat_capacity

	return 1 - exp(- Constants.time_per_turn / (PI / 4 * flammable_rate * release_rate))

func is_spread(from: Tile, to: Tile, _direction: Array[int]) -> bool:
	var fixed_prob = _fixed_prob(from.material, to.material)

	print(fixed_prob)

	return randf_range(0, 1) < fixed_prob
