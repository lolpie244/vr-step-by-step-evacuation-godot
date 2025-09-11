extends Node3D

class_name GridItem

var _x: int
var _y: int

var pos: Vector2i:
	get():
		return Vector2i(_x, _y)

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

	for child in get_children():
		if child.has_method(&"init"):
			child.init()


func _get_model_scale(model_: Node3D) -> float:
	var model_size = Utils.get_aabb(model_).size * model_.scale
	return grid.tile_size / max(model_size.x, model_size.z)


func _resize_model(model_: Node3D):
	model_.visible = true
	model_.scale = Vector3.ONE * _get_model_scale(model_)
	model_.position *= model_.scale

	return model_


func direction_to(to: GridItem) -> Vector2:
	return Vector2(to.pos.x - _x, to.pos.y - _y)


func get_mixin(type):
	return Utils.find_child_with_type(self, type, false)

func remove_mixin(type):
	var mixin: Node3D = get_mixin(type)
	if mixin != null:
		self.remove_child(mixin)
		mixin.free()


func set_material(_material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):

		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)

func restore_material():
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(i, null)


func _duplicate():
	var result = duplicate(Utils.DEFAULT_DUPLICATE)

	return result
