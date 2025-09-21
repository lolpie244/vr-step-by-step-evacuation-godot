class_name CharacterStrategic
extends Node3D

@export var type: Character.Type = Character.Type.CIVILIAN

var impl: Character = null
var _tile_changed: bool = false

@onready var pickable: XRToolsPickable = $PickableObject
@onready var model = $Model


func init(_impl: Character):
	impl = _impl


func _ready() -> void:
	hide()
	impl.tile_changed.connect(_on_impl_tile_changed)
	impl.look_direction_changed.connect(_on_look_direction_changed)
	pickable.picked_up.connect(_on_picked_up)
	pickable.dropped.connect(_on_dropped)


func _process(_delta: float) -> void:
	if pickable.is_picked_up():
		self.global_transform = pickable.global_transform


func _on_picked_up(_holder) -> void:
	_tile_changed = false
	GameCore.selected_character = null


func _on_dropped(_pickable) -> void:
	(
		(func():
			if !_tile_changed:
				impl.restore()
			_tile_changed = false)
		. call_deferred()
	)


func on_poke():
	impl.toggle_select()


func _on_impl_tile_changed(_tile: Tile) -> void:
	_tile_changed = true
	show()


func _on_look_direction_changed(direction: Vector2):
	self.rotate_y(direction.angle() - self.rotation.y)


func set_material(_material: ShaderMaterial):
	for mesh in Utils.find_children_with_type(self, MeshInstance3D, true):
		for i in mesh.get_surface_override_material_count():
			var albedo = mesh.get_active_material(i).albedo_texture
			_material.set_shader_parameter("_albedo", albedo)
			mesh.set_surface_override_material(i, _material)
