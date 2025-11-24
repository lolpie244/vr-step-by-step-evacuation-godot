class_name Smokable
extends TileMixin

signal state_changed(state: State)
signal strength_changed(state: State)

enum State { NO_SMOKE, SMOKE }

var state: State:
	set(val):
		if state == val:
			return
		state = val
		state_changed.emit(state)

var strength := 0.1:
	set(val):
		val = clamp(val, 0, 1)
		if strength == val:
			return
		strength = val
		strength_changed.emit(strength)

var wind: Vector2
var _smoke_turn: int = -1


func init():
	var flammable: Flammable = _tile.get_mixin(Flammable)
	if flammable:
		flammable.state_changed.connect(_on_flammable_state_changed)


func smoke():
	state = State.SMOKE
	_smoke_turn = GameCore.current_turn


func process_turn(_turn_number):
	if state != State.SMOKE || _turn_number == 0 || _smoke_turn == _turn_number:
		return
	if strength < 1:
		strength += Constants.SMOKE_STRENGTH_INSCREASE_RATE

	for next_tile in _tile.neighbor_tiles():
		if SmokeSpreading.is_spread(_tile, next_tile):
			next_tile.get_mixin(Smokable).smoke()


func _on_flammable_state_changed(_flammable: Flammable, _state: Flammable.State):
	if state == Flammable.State.BURNING:
		strength = max(strength, 0.5)
