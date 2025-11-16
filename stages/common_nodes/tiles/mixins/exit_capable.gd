extends Node

var impl: ExitCapable

@onready var tile: TileNode = get_parent()


func _ready():
	if !tile.impl:
		return
	impl = tile.impl.get_or_create_mixin(ExitCapable)
