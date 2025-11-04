class_name MapBuilderItem
extends Node3D

var impl: Item

@onready var sprite: Sprite3D = $Sprite


func sprite_size() -> Vector2:
	return sprite.texture.get_size() * sprite.pixel_size


func _ready() -> void:
	scale = Vector3.ONE * (1.0 / (Constants.TILE_SIZE_IN_PX * sprite.pixel_size))


func set_texture(texture):
	sprite.texture = texture
	var sprite_pos: Vector2 = (
		Vector2.ONE * Constants.TILE_SIZE_IN_PX / 2.0 * sprite.pixel_size - sprite_size()
	)
	sprite.position = Vector3(sprite_pos.x, sprite_pos.y, 0)


func set_impl(_impl):
	impl = _impl
	impl.placed.connect(_on_placed)


func _on_placed(_tile: Tile):
	show()
	self.rotation.y = -impl.rotation
