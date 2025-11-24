class_name FireAlarm
extends Item

signal triggered

var _is_triggered: bool = false


func _init():
	super._init(Vector2.ONE)
	triggered.connect(GameCore.trigger_alarm)


func get_type():
	return "FireAlarm"


func trigger():
	if _is_triggered:
		return false
	_is_triggered = true
	triggered.emit()


func is_triggered():
	return _is_triggered


func _relative_direction(direction: Utils.Direction) -> Utils.Direction:
	return ((_direction + direction) % Utils.Direction.size()) as Utils.Direction


func _is_valid_tile(tile: Tile) -> bool:
	if !tile.is_wall_like:
		return false

	var front_tile := tile.tile_in_direction(_relative_direction(Utils.Direction.UP))
	var left_tile := tile.tile_in_direction(_relative_direction(Utils.Direction.LEFT))
	var right_tile := tile.tile_in_direction(_relative_direction(Utils.Direction.RIGHT))

	return (
		front_tile
		and not front_tile.is_wall_like
		and left_tile
		and left_tile.is_wall_like
		and right_tile
		and right_tile.is_wall_like
	)
