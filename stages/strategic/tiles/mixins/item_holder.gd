extends Node3D

enum ContactPoint { BOTTOM, TOP, BACK, FRONT, LEFT, RIGHT }

@export var contact_point: ContactPoint = ContactPoint.BOTTOM

var impl: ItemHolder

@onready var tile: TileNode = get_parent()


func _ready() -> void:
	if !tile.impl:
		return
	impl = tile.impl.get_or_create_mixin(ItemHolder)
	impl.item_placed.connect(_on_item_placed)


func _get_item_node(item: Item) -> ItemNode:
	return tile.map.get_item_node(item)

func _get_contact_point(node: Node3D) -> Vector3:
	var aabb := Utils.get_aabb(node)

	match contact_point:
		ContactPoint.TOP:
			return node.position + Vector3(0, aabb.size.y, 0)
		ContactPoint.BACK:
			return aabb.get_center() - Vector3(aabb.size.x / 2, 0, 0)
		ContactPoint.FRONT:
			return aabb.get_center() + Vector3(aabb.size.x / 2, 0, 0)
		ContactPoint.LEFT:
			return aabb.get_center() - Vector3(0, 0, aabb.size.z / 2)
		ContactPoint.RIGHT:
			return aabb.get_center() + Vector3(0, 0, aabb.size.z / 2)

	return node.position


func _on_item_placed(item: Item):
	var item_node: ItemNode = _get_item_node(item)

	if !item_node.get_parent():
		tile.add_child(item_node)

	if tile.get_parent() != get_parent():
		item_node.reparent(tile, false)

	item_node.position = Vector3.ZERO
	item_node.position = self.position - _get_contact_point(item_node) + item_node.position
	item_node.rotate_y(-item.rotation)
