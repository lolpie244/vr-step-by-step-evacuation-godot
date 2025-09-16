extends Node3D
class_name TileNode
const _implements := "TileNode"

@onready var Impl: Tile = $Impl
@onready var model = $Model

func _set_impl(impl: Tile) -> void:
	Impl.set_from(impl)

func _swap_model(new_model):
	if model == new_model:
		return
	self.remove_child(model)
	self.add_child(new_model)
	model.free()
	model = new_model

func init():
	_swap_model(_get_model())

	self.scale = Vector3.ONE * Impl.grid.model_scale(model)
	self.position = Impl.grid.tile_position(Impl.pos.x, Impl.pos.y)


func _get_model():
	return model


func tile_scale(scale_: int):
	self.position = self.position / self.scale * scale_
	self.scale = Vector3.ONE * scale_


func set_material(_material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)


func _on_impl_highlight_changed(value: bool) -> void:
	if value:
		$Animation.play("highlight")
	else:
		$Animation.play_backwards("highlight")
