class_name TileNode
extends Node3D
const IMPLMENTS := "TileNode"

@export var type: Tile.Type = Tile.Type.NONE

var impl: Tile
var map: Map

@onready var model = $Model
@onready var animation: AnimationPlayer = get_node_or_null("Animation")


func set_data(_impl: Tile):
	impl = _impl


func _swap_model(new_model):
	if model == new_model:
		return
	self.remove_child(model)
	self.add_child(new_model)
	model.free()
	model = new_model


func init():
	visible = true
	impl.init()

	impl.highlight_changed.connect(_on_impl_highlight_changed)

	_swap_model(_get_model())


func _get_model():
	return model

func size() -> Vector3:
	return Utils.get_aabb(model).size * model.scale.x


func set_material(_material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)


func _on_impl_highlight_changed(value: bool) -> void:
	if !animation:
		return
		
	if animation.is_playing():
		await animation.animation_finished
	if value:
		animation.play("highlight")
	else:
		animation.play_backwards("highlight")
