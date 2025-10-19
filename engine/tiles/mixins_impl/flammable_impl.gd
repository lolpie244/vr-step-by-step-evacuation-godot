class_name Flammable
extends TileMixin

signal state_changed(state: State)
signal strength_changed(strength: float)

enum State {
	NOT_BURNING = 1 << 0,
	BURNING = 1 << 1,
	BURNED = 1 << 2,
}

enum FireType {
	A,  # Solids
	B,  # Liquids
	C,  # Gasses
	D,  # Metals
	E,  # Energy
	F,  # Oils
}

var material: TileMaterial
var wind := Vector2.ZERO

var strength := 0.95:
	set(value):
		if strength == value:
			return
		strength = value
		strength_changed.emit(value)

var state := State.NOT_BURNING:
	set(value):
		if state == value:
			return
		state = value
		state_changed.emit(state)

var _ignition_turn: int = -1


func can_burn():
	return state == State.NOT_BURNING


func ignite():
	state = State.BURNING
	_tile.remove_mixin(Walkable)
	_ignition_turn = GameCore.current_turn


func process_turn(_turn_number):
	if state != State.BURNING || _turn_number == 0 || _ignition_turn == _turn_number:
		return

	extinguish(0.1)

	for next_tile in _tile.neighbor_tiles():
		if FireSpreading.is_spread(_tile, next_tile):
			next_tile.get_mixin(Flammable).ignite()


func extinguish(foam_strength: float):
	if state != State.BURNING:
		return

	strength -= foam_strength

	if strength < 0:
		state = State.NOT_BURNING
