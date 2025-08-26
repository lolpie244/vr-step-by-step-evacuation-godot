extends Node3D

class_name GridItem

var _x: int
var _y: int
var grid: MapGrid

var _flags: int = 0


func has_flag(f) -> bool:
	return (_flags & f) != 0


func add_flag(f) -> void:
	_flags |= f


func remove_flag(f) -> void:
	_flags &= ~f


func _init(grid_: MapGrid, x_: int, y_: int):
	self._x = x_
	self._y = y_
	self.grid = grid_


func init():
	self.grid.add_child(self)


func _get_model_scale(model_: Node3D) -> float:
	var model_size = Utils.get_aabb(model_).size
	return grid.tile_size / max(model_size.x, model_size.z)


func _resize_model(model_: Node3D):
	model_.visible = true
	model_.scale = Vector3.ONE * _get_model_scale(model_)
	model_.position *= model_.scale

	return model_


func get_x():
	return _x

func get_y():
	return _y
