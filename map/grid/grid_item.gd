extends Node3D

class_name GridItem

var x: int
var y: int
var grid: MapGrid

var grid_model


func set_grid_item_data(grid_: MapGrid, x_: int, y_: int):
	self.x = x_
	self.y = y_
	self.grid = grid_

func init():
	self.grid_model = _generate_model()
	self.add_child(self.grid_model)
	self.position = grid.tile_position(x, y)

	self.grid.add_child(self)


func _get_model_scale(model_: Node3D) -> float:
	var model_size = Utils.get_aabb(model_).size
	return grid.tile_size / max(model_size.x, model_size.z)


func _resize_model(model_: Node3D):
	model_.visible = true
	model_.scale = Vector3.ONE * _get_model_scale(model_)
	model_.position *= model_.scale

	return model_

func _generate_model():
	assert(false, "Not implemented")
