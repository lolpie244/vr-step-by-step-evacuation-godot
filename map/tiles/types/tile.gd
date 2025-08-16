extends GridItem

class_name Tile

enum Flags {
	WALL = 1 << 0,
	WALKABLE = 1 << 1,
}

var _flags: int = 0
var _model: Node3D

func has_flag(f: Flags) -> bool:
	return (_flags & f) != 0

func add_flag(f: Flags) -> void:
	_flags |= f

func remove_flag(f: Flags) -> void:
	_flags &= ~f

func set_tile_data(grid_, x_, y_, model_, flags_) -> void:
	assert(model_ != null, "Model is not valid")
	self._model = model_
	self._flags = flags_

	super.set_grid_item_data(grid_, x_, y_)

func _generate_model():
	return _resize_model(_model.duplicate())
