extends GridItem

class_name Tile

enum Flags {
	WALL = 1 << 0,
	WALKABLE = 1 << 1,
}

var _flags: int = 0
var _model: Node3D
var _shared_data: TileFactory.SharedData


func has_flag(f: Flags) -> bool:
	return (_flags & f) != 0


func add_flag(f: Flags) -> void:
	_flags |= f


func remove_flag(f: Flags) -> void:
	_flags &= ~f


func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data
	self._flags = _shared_data.flags

	super._init(grid_, x_, y_)


func init():
	self._model = _generate_model()
	self.add_child(_model)

	super.init()


func add_character(character: Character) -> bool:
	character.x = self._x
	character.y = self._y
	character.transform = self.transform

	if _shared_data.character_point != null:
		_shared_data.character_point.place_character(character)

	return true


func _generate_model():
	return _resize_model(_shared_data.model.duplicate())
