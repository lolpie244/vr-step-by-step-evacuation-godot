extends Node3D
class_name Character

signal tile_changed(tile: Tile, direction: Vector2)

enum Type { Civilian }

@export var base_speed: int = 5
@export var type: Type = Type.Civilian

var _speed: int
var _walkable: Walkable
var _reachable: Array[Walkable.ReachableResult] = []

func _init():
	_speed = base_speed

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

	highlight_reachable(false)
	_speed -= next_tile.distance
	_walkable = next_tile.tile.get_mixin(Walkable)
	_reachable = _walkable.reachable_tiles(_speed)
	tile_changed.emit(_walkable.get_tile(), next_tile.direction)

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


var _reachable_highlighted := false
func highlight_reachable(highlight: bool):
	if _reachable_highlighted == highlight:
		return

	_reachable_highlighted = highlight
	for info in _reachable:
		await Engine.get_main_loop().create_timer(0.04).timeout
		info.tile.highlight = highlight


func visible_tiles():
	var tiles := ShadowCasting.visible_tiles(_walkable.get_tile())
	for tile in tiles:
		if tile != null:
			tile.highlight = true
