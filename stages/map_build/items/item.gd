@tool
class_name MapBuilderItem
extends Node3D

@export var icon: Texture2D
@export var size: Vector2i = Vector2i.ONE
@export var mesh_instance: PackedScene

@onready var sprite: Sprite3D = $Sprite
@onready var body: XRToolsPickable = $BodyOrigin/Body
@onready var model: Node3D = $BodyOrigin/Body/Model
@onready var snap_zone: XRToolsSnapZone = $BodyOrigin/SnapZone
@onready var area: Area3D = $BodyOrigin/Body/Area3D


func _ready():
	if icon:
		sprite.texture = icon
		sprite.hide()

	if mesh_instance:
		model.add_child(mesh_instance.instantiate())


func _get_impl():
	assert(false, "Not implemented")


func _on_action_pressed(_pickable: Variant) -> void:
	var tile: Tile2D = null
	for tile_body in area.get_overlapping_bodies():
		if tile == null or body.global_position.distance_to(tile_body.global_position):
			tile = tile_body

	print(body.global_rotation)


func _on_model_dropped(pickable: Variant) -> void:
	snap_zone.pick_up_object(pickable)
