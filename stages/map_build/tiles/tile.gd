class_name Tile2D
extends Area3D

@export var type: Tile.Type = Tile.Type.NONE
@export var texture: Texture2D

var impl: Tile

@onready var background: Sprite3D = $Background
@onready var sprite: Sprite3D = $Background/Texture
@onready var debug_text: Label3D = $Background/DebugText


func set_impl(_impl: Tile):
	impl = _impl


func _ready() -> void:
	sprite.texture = texture
	background.custom_aabb = AABB()
	var size := background.texture.get_size() * background.pixel_size
	background.custom_aabb.size = Vector3(size.x, 0.01, size.y)


func init():
	tile2d_init()


func tile2d_init():
	visible = true

	if Constants.DEBUG_MODE:
		debug_text.show()
		debug_text.text = "{0}".format([impl.pos])


func get_aabb():
	return background.custom_aabb
