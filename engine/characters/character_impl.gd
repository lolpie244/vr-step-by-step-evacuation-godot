class_name Character
extends RefCounted

signal tile_changed(tile: Tile)
signal look_direction_changed(direction: Vector2)
signal highlihted
signal saved(character: Character)
signal death(character: Character)
signal enabled_changed(value: bool)

enum Type { CIVILIAN }

@export var base_speed: int = 5
@export var type: Type = Type.CIVILIAN

var inventory: Array[Item] = []

var enabled: bool = false:
	set(value):
		if value == enabled:
			return
		enabled = value
		reset_visible()
		enabled_changed.emit(enabled)

var _speed: int
var _is_selected: bool = false
var _is_highlighted: bool = false

var _walkable: Walkable:
	set(value):
		if _walkable:
			_walkable.set_reachable(self, false)
		_walkable = value
		if _walkable:
			_walkable.set_reachable(self, true)

var _look_direction: Vector2 = Vector2.ZERO:
	set(value):
		_look_direction = value
		look_direction_changed.emit(value)

var _reachable: Array[Walkable.ReachableResult] = []:
	set(val):
		for reachable in _reachable:
			reachable.tile.get_mixin(Walkable).set_reachable(self, false)

		_reachable = val

		for reachable in _reachable:
			reachable.tile.get_mixin(Walkable).set_reachable(self, true)

var _visible: Array[Tile] = []:
	set(val):
		for tile in _visible:
			tile.get_mixin(Visible).set_visible(self, false)

		_visible = val
		if !enabled:
			return
		for tile in _visible:
			tile.get_mixin(Visible).set_visible(self, true)


func _init(_type: Type):
	_speed = base_speed
	type = _type

	GameCore.alarm_triggered.connect(func(): self.enabled = true)


func process_turn(_turn_number: int):
	_speed = base_speed
	if _walkable:
		reset_reachable()


func place(tile: Tile):
	var walkable := tile.get_mixin(Walkable) as Walkable
	if walkable == null:
		return false

	if walkable == _walkable:
		return true

	var next_tile = is_reachable(walkable)
	if next_tile == null || !walkable.place_character(self):
		if _walkable:
			_walkable.place_character(self)
		return false

	select(false)
	_speed -= next_tile.distance
	_walkable = next_tile.tile.get_mixin(Walkable)
	reset_reachable()
	reset_visible()
	_look_direction = next_tile.direction
	tile_changed.emit(_walkable.get_tile())

	return true


func reset_visible():
	var timer := Metrics.start_timer("CharacterVisible")
	_visible = visible_tiles()
	timer.stop()


func reset_reachable():
	var timer := Metrics.start_timer("CharacterReachable")
	_reachable = _walkable.reachable_tiles(_speed)
	timer.stop()


func restore():
	_walkable.place_character(self)


func is_reachable(walkable: Walkable) -> Walkable.ReachableResult:
	if _walkable == null:
		return Walkable.ReachableResult.new(walkable.get_tile(), 0, Vector2.ZERO)

	for next_tile in _reachable:
		if next_tile.tile == walkable.get_tile():
			return next_tile
	return null


func visible_tiles() -> Array[Tile]:
	if !_walkable:
		return []

	var result := ShadowCasting.visible_tiles(_walkable.get_tile())
	result.append(_walkable.get_tile())
	return result


func get_tile() -> Tile:
	if !_walkable:
		return null

	return _walkable.get_tile()


func select(value: bool):
	if _is_selected == value:
		return
	_is_selected = value
	if _is_selected:
		GameCore.selected_character = self
	elif GameCore.selected_character == self:
		GameCore.selected_character = null


func toggle_select():
	select(!_is_selected)


func _highlight(value: bool):
	if _is_highlighted == value:
		return

	_is_highlighted = value
	get_tile().highlight = value

	for info in _reachable:
		await Engine.get_main_loop().create_timer(0.04).timeout
		info.tile.highlight = value

	highlihted.emit()


func _remove():
	enabled = false
	_walkable = null
	_visible = []
	_reachable = []


func save():
	_remove()
	saved.emit(self)


func kill():
	_remove()
	death.emit(self)
