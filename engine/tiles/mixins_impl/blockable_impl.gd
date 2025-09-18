extends TileMixin
class_name Blockable

signal blocking_changed(value: bool)

var blocking := true:
	set(value):
		if blocking == value:
			return
		blocking = value

var is_wall_like := true
