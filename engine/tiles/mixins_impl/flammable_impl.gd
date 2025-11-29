class_name Flammable
extends TileMixin

signal state_changed(flammable: Flammable, state: State)
signal strength_changed(flammable: Flammable, strength: float)
signal durability_changed(flammable: Flammable, durability: float)

enum State {
	NOT_BURNING,
	BURNING,
	BURNED,
}

var wind := Vector2.ZERO

var strength: float = 0:
	set(value):
		if strength == value:
			return
		strength = value
		strength_changed.emit(self, value)

var durability: float = 1:
	set(value):
		if durability == value:
			return
		durability = value
		durability_changed.emit(self, value)

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
		item_holder.item_part_placed.connect(_on_item_placed)
		item_holder.item_part_removed.connect(_on_item_removed)
		item_holder.item_removed.connect(_on_item_removed)


func can_burn():
	var blockable: Blockable = _tile.get_mixin(Blockable)
	return state == State.NOT_BURNING and (!blockable or !blockable.blocking)


func ignite():
	strength = 0.1
	state = State.BURNING
	_ignition_turn = GameCore.current_turn

	var smokable: Smokable = _tile.get_mixin(Smokable)
	if smokable:
		smokable.smoke()


func process_turn(_turn_number):
	if state != State.BURNING || _turn_number == 0 || _ignition_turn == _turn_number:
		return

	strength += Constants.IDLE_FLAME_INCREASE
	durability -= Constants.IDLE_DURABILITY_DECREASE * strength

	if durability <= 0:
		state = State.BURNED
	elif strength > 1:
		strength = 1

	for next_tile in _tile.neighbor_tiles():
		if FireSpreading.is_spread(_tile, next_tile):
			next_tile.get_mixin(Flammable).ignite()


func extinguish(foam_strength: float):
	if state != State.BURNING:
		return

	strength -= foam_strength

	if strength < 0:
		state = State.NOT_BURNING

	if strength > 1:
		state = State.BURNED

		for next_tile in _tile.neighbor_tiles():
			if next_tile.get_mixin(Flammable):
				next_tile.get_mixin(Flammable).ignite()
		strength = 0.0
		durability = 0.0


func _on_item_placed(item: Item):
	if item.material:
		_item_material = item.material


func _on_item_removed(_item: Item):
	_item_material = null
