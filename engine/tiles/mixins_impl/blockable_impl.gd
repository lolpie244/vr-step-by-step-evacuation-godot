class_name Blockable
extends TileMixin

signal blocking_changed(value: bool)

var blocking := true:
	set(value):
		if blocking == value:
			return
		blocking = value
		blocking_changed.emit(blocking)
		_update_walkable()


func init():
	_update_walkable()


func _update_walkable():
	var walkable: Walkable = _tile.get_mixin(Walkable)
	if walkable:
		walkable.set_blocker(self, blocking)
