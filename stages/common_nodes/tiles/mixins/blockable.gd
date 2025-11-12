extends Node3D

@export var blocking: bool = true

var impl: Blockable

@onready var tile: TileNode = get_parent()


func _ready():
	if !tile.impl:
		return
	impl = tile.impl.get_or_create_mixin(Blockable)


func init():
	impl.blocking = blocking
