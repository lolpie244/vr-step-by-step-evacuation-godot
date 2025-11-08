class_name Flammable
extends TileMixin

signal state_changed(flammable: Flammable, state: State)
signal strength_changed(strength: float)

enum State {
	NOT_BURNING,
	BURNING,
	BURNED,
}

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
		state_changed.emit(self, state)

		var walkable: Walkable = _tile.get_mixin(Walkable)
		if walkable:
			walkable.set_blocker(self, state != State.NOT_BURNING)

var material: FlammableMaterial:
	get():
		if !_item_material:
			return _tile_material
		return _item_material

var _tile_material: FlammableMaterial
var _item_material: FlammableMaterial
var _ignition_turn: int = -1


func init():
	var item_holder: ItemHolder = _tile.get_mixin(ItemHolder)
	if item_holder:
		item_holder.item_placed.connect(_on_item_placed)
		item_holder.item_removed.connect(_on_item_removed)


func can_burn():
	return state == State.NOT_BURNING


func ignite():
	state = State.BURNING
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


func _on_item_placed(item: Item):
	if item.material:
		_item_material = item.material.duplicate()
		_item_material.wind = _tile_material.wind


func _on_item_removed(_item: Item):
	_item_material = null
