class_name TileNode
extends Node3D
const IMPLEMENTS := "TileNode"

@export var type: Tile.Type = Tile.Type.NONE
@export var model_adapter_class: Script

var impl: Tile

@onready var model = $Model
@onready var animation: AnimationPlayer = get_node_or_null("Animation")
@onready var model_adapter: TileModelAdapter = self.model_adapter_class.new()


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

	_swap_model(model_adapter.get_model(impl, model))


func _get_model():
	return model


func size() -> Vector3:
	return Utils.get_aabb(model).size * model.scale.x


func set_material(_material: ShaderMaterial):
	model_adapter.set_material(model, _material)


func _on_impl_highlight_changed(value: bool) -> void:
	if !animation:
		return

	if animation.is_playing():
		await animation.animation_finished
	if value:
		animation.play("highlight")
	else:
		animation.play_backwards("highlight")
