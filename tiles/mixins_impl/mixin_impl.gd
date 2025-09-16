extends BaseImpl
class_name TileMixinImpl
const _implements := "TileMixinImpl"

@onready var _tile: Tile = Utils.find_parent_that_implements(self, "TileImpl").instance

func get_tile() -> Tile:
	return _tile

func _set_type(type):
	var mixin = _tile.get_mixin(type)
	if mixin:
		set_instance(mixin)
	else:
		_tile.mixins.append(self)

func _exit_tree():
	if instance == self:
		_tile.mixins.erase(self)
