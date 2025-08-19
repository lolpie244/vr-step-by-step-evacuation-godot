extends GridItem

class_name Tile

enum Flags {
	WALL = 1 << 0,
	WALKABLE = 1 << 1,
}

var _model: Node3D
var _shared_data: TileFactory.SharedData

func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data
	self._flags = _shared_data.flags

	super._init(grid_, x_, y_)


func init():
	self._model = _generate_model()
	self.add_child(_model)

	self.position = grid.tile_position(x, y)

	super.init()


func add_character(character: Character) -> bool:
	character.x = self.x
	character.y = self.y
	character.transform = self.transform

	if _shared_data.character_point != null:
		_shared_data.character_point.place_character(character)

	return true


func _generate_model():
	return _resize_model(_shared_data.model.duplicate())
