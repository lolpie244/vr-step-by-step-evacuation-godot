extends Node

# Constants
const contact_heat_fraction := 0.2 # fraction of heat that actually reaches the neighbor through direct contact
const max_strenght := 20 # max wind vector strenght
const max_strenght_prob := 0.5 # probability that fire will spread with wind with max_strenght

const k1 := 1.5 # wind influence coef
var k2 := -log(1 - max_strenght_prob) / max_strenght # wind vector length to probability

func can_burn(tile: Tile) -> bool:
	return (
		!tile.has_flag(Tile.Flags.BURNING)
		&& !tile.has_flag(Tile.Flags.BURNED)
		&& tile.material.flammable
	)


func _fixed_prob(from: Tile, to: Tile) -> float:
	var from_mat = from.material
	var to_mat = to.material

	var deltaT = to_mat.ignition_temp - Constants.room_temperature
	var HRR = contact_heat_fraction * from_mat.heat_release_rate * 1000
	var release_rate = pow(deltaT / HRR, 2)
	var flammable_rate = to_mat.density * to_mat.thermal_conductivity * to_mat.heat_capacity

	return 1 - exp(-Constants.time_per_turn / (PI / 4 * flammable_rate * release_rate))

func _dynamic_prob(from: Tile, to: Tile) -> float:
	var vector = from.wind

	var a := k1 * vector.length()
	var b := (k1 / 2.0) * vector.length()

	var elipse_angle := vector.angle()
	var angle_to := from.direction_to(to).angle()

	var point_on_elips := Vector2(
		a * cos(angle_to) * cos(elipse_angle) - b * sin(angle_to) * sin(elipse_angle),
		a * cos(angle_to) * sin(elipse_angle) + b * sin(angle_to) * cos(elipse_angle)
	)

	return k2 * point_on_elips.length()


func is_spread(from: Tile, to: Tile) -> bool:
	if !can_burn(to):
		return false

	var fixed_prob = _fixed_prob(from, to)
	var dynamic_prob = _dynamic_prob(from, to)

	print("COORD ", from.pos, to.pos)
	print("WIND ", from.wind)
	print("DIRECTION ", from.direction_to(to))
	print("FIXED ", fixed_prob)
	print("DYNAMIC ", dynamic_prob)
	print("RESULT ", fixed_prob + dynamic_prob)
	print("---------")

	return randf_range(0, 1) < fixed_prob + dynamic_prob
