class_name MapBuilderItem
extends Node3D

var impl: Item
var _direction: Utils.Direction = Utils.Direction.UP

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


func _get_offset_for_direction(direction: Utils.Direction) -> Vector3:
	match direction:
		Utils.Direction.DOWN:
			return Vector3(-1, 0, 0)
		Utils.Direction.LEFT:
			return Vector3(0, 0, -1)
		Utils.Direction.RIGHT:
			return Vector3(0, 0, 1)
	return Vector3.ZERO


func _on_placed(_tile: Tile):
	show()
	self.rotation.y = -impl.rotation

	if (
		impl.get_direction() == _direction
		or impl.size.x == 1
		or (impl.get_direction() in [Utils.Direction.LEFT, Utils.Direction.RIGHT] and impl.size.y == 1)
	):
		return

	self.position = (
		-_get_offset_for_direction(_direction) + _get_offset_for_direction(impl.get_direction())
	)
	_direction = impl.get_direction()
