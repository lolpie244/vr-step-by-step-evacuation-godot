extends Node3D
class_name TileMixinImpl
const _implements := "TileMixinImpl"

@onready var _tile: Tile = Utils.find_parent_that_implements(self, "TileImpl")

func get_tile() -> Tile:
	return _tile


func _ready():
	_tile.mixins.append(self)


func _exit_tree():
	_tile.mixins.erase(self)
