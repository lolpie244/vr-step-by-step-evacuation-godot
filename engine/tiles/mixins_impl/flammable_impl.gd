class_name Flammable
extends TileMixin

signal state_changed(state: State)
signal strenght_changed(strenght: float)

enum State {
	NOT_BURNING = 1 << 0,
	BURNING = 1 << 1,
	BURNED = 1 << 2,
}

var material: TileMaterial

var strenght := 1.0:
	set(value):
		if strenght == value:
			return
		strenght = value
		strenght_changed.emit(value)

var state := State.NOT_BURNING:
	set(value):
		if state == value:
			return
		state = value
		state_changed.emit(state)


func can_burn():
	return state == State.NOT_BURNING


func ignite():
	state = State.BURNING
	_tile.remove_mixin(Walkable)

	state_changed.emit(state)


func spread_fire():
	if state != State.BURNING:
		return

	for next_tile in _tile.neighbor_tiles():
		if FireSpreading.is_spread(_tile, next_tile):
			next_tile.get_mixin(Flammable).ignite()


func extinguish(foam_strenght: float):
	if state != State.BURNING:
		return

	strenght -= foam_strenght * 0.002

	if strenght < 0:
		state = State.NOT_BURNING
