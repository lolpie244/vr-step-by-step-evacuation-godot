class_name TileNode
extends Node3D
const IMPLMENTS := "TileNode"

@export var type: Tile.Type = Tile.Type.NONE

var impl: Tile

var map: Map
var _tile_size: float

@onready var model = $Model


func set_data(tile_size: float, _impl: Tile):
	_tile_size = tile_size
	impl = _impl


func set_map(_map: Map):
	map = _map


func _swap_model(new_model):
	if model == new_model:
		return
	self.remove_child(model)
	self.add_child(new_model)
	model.free()
	model = new_model


func init():
	impl.init()

	impl.highlight_changed.connect(_on_impl_highlight_changed)

	_swap_model(_get_model())

	self.scale = Vector3.ONE * model_scale(model)
	self.position = tile_position(impl.pos.x, impl.pos.y)


func _get_model():
	return model


func tile_scale(_scale: int):
	self.position = self.position / self.scale * _scale
	self.scale = Vector3.ONE * _scale


func set_material(_material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)


func _on_impl_highlight_changed(value: bool) -> void:
	if $Animation.is_playing():
		await $Animation.animation_finished
	if value:
		$Animation.play("highlight")
	else:
		$Animation.play_backwards("highlight")


func tile_position(x, y) -> Vector3:
	return (
		Vector3(_tile_size * x, 0, _tile_size * y)
		- (Vector3(impl.grid.rows_count(), 0, impl.grid.columns_count()) * _tile_size / 2)
		+ Vector3(_tile_size, 0, _tile_size) / 2
	)


func model_scale(_model) -> float:
	var model_size = Utils.get_aabb(_model).size * _model.scale
	return _tile_size / max(model_size.x, model_size.z)
