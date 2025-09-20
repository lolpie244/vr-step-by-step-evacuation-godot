class_name Character
extends Node3D

signal tile_changed(tile: Tile)
signal selected_changed(is_selected: bool)

enum Type { CIVILIAN }

@export var base_speed: int = 5
@export var type: Type = Type.CIVILIAN

var _speed: int
var _walkable: Walkable
var _reachable: Array[Walkable.ReachableResult] = []
var _is_selected := false

var _look_direction: Vector2 = Vector2.ZERO


func _init(_type: Type):
	_speed = base_speed
	type = _type


func process_turn(_turn_number: int):
	_speed = base_speed
	_reachable = _walkable.reachable_tiles(_speed)


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
	_reachable = _walkable.reachable_tiles(_speed)
	_look_direction = next_tile.direction
	tile_changed.emit(_walkable.get_tile())

	return true


func restore():
	_walkable.place_character(self)


func is_reachable(walkable: Walkable) -> Walkable.ReachableResult:
	if _walkable == null:
		return Walkable.ReachableResult.new(walkable.get_tile(), 0, Vector2.ZERO)

	for next_tile in _reachable:
		if next_tile.tile == walkable.get_tile():
			return next_tile
	return null


func select(is_selected: bool, animation: bool = true):
	if is_selected == _is_selected:
		return
	_is_selected = is_selected
	selected_changed.emit(is_selected)

	for info in _reachable:
		if animation:
			await Engine.get_main_loop().create_timer(0.04).timeout
		info.tile.highlight = _is_selected


func visible_tiles() -> Array[Tile]:
	return ShadowCasting.visible_tiles(_walkable.get_tile())


func get_tile() -> Tile:
	if !_walkable:
		return null

	return _walkable.get_tile()
