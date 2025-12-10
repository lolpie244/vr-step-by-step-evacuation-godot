extends Node

# Constants

# fraction of heat that actually reaches the neighbor through direct contact
const MAX_STRENGHT := 20  # max wind vector strength
const MAX_STRENGHT_PROB := 0.6  # probability that fire will spread with wind with MAX_STRENGHT

const K1 := 1.3  # wind influence coef
var k2 := -log(1 - MAX_STRENGHT_PROB) / MAX_STRENGHT  # wind vector length to probability


func can_burn(tile: Tile) -> bool:
	var flammable: Flammable = tile.get_mixin(Flammable)

	return flammable != null && flammable.can_burn()


func _fixed_prob(from: Tile, to: Tile) -> float:
	var from_mat = from.get_mixin(Flammable).material
	var to_mat = to.get_mixin(Flammable).material

	var delta_t = to_mat.ignition_temp - Constants.ROOM_TEMPERATURE
	var heating_rate = pow(delta_t / from_mat.hrr, 2)

	return 1 - exp(-Constants.TIME_PER_TURN / (to_mat.flammable_rate * heating_rate))


func _dynamic_prob(from: Tile, to: Tile) -> float:
	var vector: Vector2 = from.get_mixin(Flammable).wind

	var a := K1 * vector.length()
	var b := (K1 / 2.0) * vector.length()

	var elipse_angle: float = vector.angle()
	var angle_to := from.direction_to(to).angle()

	var point_on_elips := Vector2(
		a * cos(angle_to) * cos(elipse_angle) - b * sin(angle_to) * sin(elipse_angle),
		a * cos(angle_to) * sin(elipse_angle) + b * sin(angle_to) * cos(elipse_angle)
	)

	return k2 * point_on_elips.length()


func is_spread(from: Tile, to: Tile) -> bool:
	if to.get_mixin(Flammable) == null || !to.get_mixin(Flammable).can_burn():
		return false

	var fixed_prob = _fixed_prob(from, to)
	var dynamic_prob = _dynamic_prob(from, to)

	if Constants.DEBUG_MODE:
		print("Fire spreading:")
		print("	COORD ", from.pos, to.pos)
		print("	DIRECTION ", from.direction_to(to))
		print("	FIXED ", fixed_prob)
		print("	DYNAMIC ", dynamic_prob)
		print("	RESULT ", fixed_prob + dynamic_prob)
		print("")

	return (
		randf()
		< (
			from.get_mixin(Flammable).strength
			* (fixed_prob + dynamic_prob)
			* Constants.fire_spreading_rate
		)
	)
