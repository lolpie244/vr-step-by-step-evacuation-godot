class_name TileNode
extends Node3D
const IMPLEMENTS := "TileNode"

@export var type: Tile.Type = Tile.Type.NONE

var impl: Tile

@onready var animation: AnimationPlayer = get_node_or_null("Animation")


func set_impl(_impl: Tile):
	impl = _impl


func init():
	visible = true
	impl.init()

	impl.highlight_changed.connect(_on_impl_highlight_changed)

	for model in Utils.find_children_with_type(self, TileMesh, false):
		var new_model = (model as TileMesh).get_transformed(impl)
		self.remove_child(model)
		self.add_child(new_model)
		model.free()


func size() -> Vector3:
	return Utils.get_aabb(self).size * self.scale.x


#func set_material(_material: ShaderMaterial):
#model_adapter.set_material(self, _material)


func _on_impl_highlight_changed(value: bool) -> void:
	if !animation:
		return

	if animation.is_playing():
		await animation.animation_finished
	if value:
		animation.play("highlight")
	else:
		animation.play_backwards("highlight")
