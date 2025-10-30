extends Node3D

var impl: Blockable

@onready var tile: TileNode = get_parent()


func _ready():
	if !tile.impl:
		return

	impl = tile.impl.get_or_create_mixin(Blockable)
