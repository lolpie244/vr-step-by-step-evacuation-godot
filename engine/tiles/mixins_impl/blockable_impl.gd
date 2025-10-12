class_name Blockable
extends TileMixin

signal blocking_changed(value: bool)

var blocking := true:
	set(value):
		if blocking == value:
			return
		blocking = value
		blocking_changed.emit(blocking)
