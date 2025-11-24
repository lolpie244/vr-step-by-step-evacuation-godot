class_name SmokeSpreading
extends Node

# Constants

# fraction of heat that actually reaches the neighbor through direct contact
const MAX_STRENGHT := 20  # max wind vector strength
const MAX_STRENGHT_PROB := 0.3  # probability that smoke will spread with wind with MAX_STRENGHT

const PASSIVE_SMOKE_SPREAD_PROB := 0.2

const K1 := 1.5  # wind influence coef
static var k2 := -log(1 - MAX_STRENGHT_PROB) / MAX_STRENGHT  # wind vector length to probability


static func can_burn(tile: Tile) -> bool:
	var flammable: Flammable = tile.get_mixin(Flammable)

	return flammable != null && flammable.can_burn()


static func _fixed_prob(from: Tile) -> float:
	var flammable: Flammable = from.get_mixin(Flammable)
	if !flammable or flammable.state != Flammable.State.BURNING:
		return PASSIVE_SMOKE_SPREAD_PROB

	var from_mat := flammable.material
	var smoke_rate := from_mat.hrr * from_mat.carbon_monoxide_yield

	return 1 - exp(-Constants.TIME_PER_TURN / smoke_rate)


static func _dynamic_prob(from: Tile, to: Tile) -> float:
	var vector: Vector2 = from.get_mixin(Smokable).wind

	var a := K1 * vector.length()
	var b := (K1 / 2.0) * vector.length()

	var elipse_angle: float = vector.angle()
	var angle_to := from.direction_to(to).angle()

	var point_on_elips := Vector2(
		a * cos(angle_to) * cos(elipse_angle) - b * sin(angle_to) * sin(elipse_angle),
		a * cos(angle_to) * sin(elipse_angle) + b * sin(angle_to) * cos(elipse_angle)
	)

	return k2 * point_on_elips.length()


static func is_spread(from: Tile, to: Tile) -> bool:
	if to.get_mixin(Smokable) == null || to.get_mixin(Smokable).state == Smokable.State.SMOKE:
		return false

	var fixed_prob = _fixed_prob(from)
	var dynamic_prob = _dynamic_prob(from, to)

	if Constants.DEBUG_MODE:
		print("Fire spreading:")
		print("	COORD ", from.pos, to.pos)
		print("	DIRECTION ", from.direction_to(to))
		print("	FIXED ", fixed_prob)
		print("	DYNAMIC ", dynamic_prob)
		print("	RESULT ", fixed_prob + dynamic_prob)
		print("")

	return randf_range(0, 1) < fixed_prob + dynamic_prob
