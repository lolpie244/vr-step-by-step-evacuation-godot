class_name Tile2D
extends Node3D

@export var type: Tile.Type = Tile.Type.NONE
@export var texture: Texture2D

var impl: Tile

@onready var background: Sprite3D = $Background
@onready var sprite: Sprite3D = $Background/Texture

func set_data(_impl: Tile):
	impl = _impl

func _ready() -> void:
	background.custom_aabb = AABB()
	var size := background.texture.get_size() * background.pixel_size
	background.custom_aabb.size = Vector3(size.x, 0.01, size.y)

func init():
	sprite.texture = texture
	visible = true

func get_aabb():
	return background.custom_aabb

func set_material(_material: ShaderMaterial):
	# TODO: fix
	return
	for _sprite in Utils.find_children_with_type(self, Sprite3D, true):
		#_material.set_shader_parameter("_albedo", _sprite.texture)
		if _sprite.texture:
			_sprite.material_override = _material
			_sprite.material_override.set_shader_parameter("_albedo", _sprite.texture)
