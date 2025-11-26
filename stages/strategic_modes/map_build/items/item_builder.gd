@tool
class_name MapBuilderItemCreator
extends Node3D

@export var icon: Texture2D
@export var size: Vector2i = Vector2i.ONE
@export var rotateable: bool = true

var type: String:
	get():
		var impl = _get_impl()
		if impl:
			return impl.get_type()
		return ""

@onready var item: MapBuilderItem = $Item
@onready var model: Node3D = $Model
@onready var body: XRToolsPickable = $BodyOrigin/Body
@onready var snap_zone: XRToolsSnapZone = $BodyOrigin/SnapZone
@onready var area: Area3D = $BodyOrigin/Body/Area3D
@onready var origin_point: Node3D = $BodyOrigin/Body/OriginPoint
@onready
var map_builder: MapBuilderScene = Utils.find_parent_that_implements(self, "MapBuilderScene")


func _ready():
	if icon:
		item.set_texture(icon)
		item.hide()

	if !Engine.is_editor_hint():
		model.reparent(body)

		origin_point.hide()


func _get_impl():
	return null


func _distance_to_tile(tile: Tile2D):
	return origin_point.global_position.distance_to(tile.global_position)


func _rotation() -> float:
	return model.global_rotation_degrees.y


func _on_action_pressed(_pickable: Variant) -> void:
	var tile: Tile2D = null

	for tile_body in area.get_overlapping_areas():
		if not tile_body is Tile2D:
			continue
		if tile == null or _distance_to_tile(tile_body) < _distance_to_tile(tile):
			tile = tile_body
	if !tile:
		return

	var impl: Item = _get_impl()
	var direction: Utils.Direction = Utils.Direction.UP

	if rotateable:
		direction = Utils.direction_from_angle(_rotation())

	if impl.is_valid_placement(tile.impl, direction):
		create_node(impl)
		impl.place(tile.impl, direction)
		tile.impl.grid.add_item(impl)


func create_node(impl: Item):
	var new_item := item.duplicate(Utils.DEFAULT_DUPLICATE)
	new_item.set_impl(impl)
	map_builder.add_item_node(new_item)


func _on_model_dropped(pickable: Variant) -> void:
	snap_zone.pick_up_object(pickable)
