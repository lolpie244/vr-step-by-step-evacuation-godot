extends TileMixin
class_name Flammable

signal state_changed(state: State)

var material: TileMaterial
var state := State.NOT_BURNING
var cooling_percentage := 0.1


enum State {
	NOT_BURNING = 1 << 0,
	BURNING = 1 << 1,
	BURNED = 1 << 2,
}

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
