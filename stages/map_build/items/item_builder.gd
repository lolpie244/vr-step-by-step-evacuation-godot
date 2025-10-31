@tool
class_name MapBuilderItemCreator
extends Node3D

@export var icon: Texture2D
@export var size: Vector2i = Vector2i.ONE

@onready var item: MapBuilderItem = $Item
@onready var model: Node3D = $Model
@onready var body: XRToolsPickable = $BodyOrigin/Body
@onready var snap_zone: XRToolsSnapZone = $BodyOrigin/SnapZone
@onready var area: Area3D = $BodyOrigin/Body/Area3D
@onready var origin_point: Node3D = $BodyOrigin/Body/OriginPoint
@onready var map_builder: MapBuilder = Utils.find_parent_that_implements(self, "MapBuilder")


func _ready():
	if icon:
		item.set_texture(icon)
		item.hide()

	if !Engine.is_editor_hint():
		model.reparent(body)

		origin_point.hide()


func _get_impl():
	assert(false, "Not implemented")


func _distance_to_tile(tile: Tile2D):
	return origin_point.global_position.distance_to(tile.global_position)


func _on_action_pressed(_pickable: Variant) -> void:
	var tile: Tile2D = null

	for tile_body in area.get_overlapping_areas():
		if tile == null or _distance_to_tile(tile_body) < _distance_to_tile(tile):
			tile = tile_body
	if !tile:
		return

	var impl: Item = _get_impl()
	var direction: Utils.Direction
	print(model.global_rotation_degrees.y)

	match snapped(model.global_rotation_degrees.y, 90):
		0:
			direction = Utils.Direction.UP
		-90:
			direction = Utils.Direction.RIGHT
		90:
			direction = Utils.Direction.LEFT
		-180:
			direction = Utils.Direction.DOWN
		180:
			direction = Utils.Direction.DOWN

	if !impl.is_valid_placement(tile.impl, direction):
		return

	var new_item := item.duplicate(Utils.DEFAULT_DUPLICATE)
	new_item.set_data(impl)
	map_builder.add_item_node(new_item)

	impl.place(tile.impl, direction)


func _on_model_dropped(pickable: Variant) -> void:
	snap_zone.pick_up_object(pickable)
