extends Node

var impl: ItemHolder
var _item_node: MapBuilderItem

@onready var tile: Tile2D = get_parent()
@onready
var map_builder: MapBuilderScene = Utils.find_parent_that_implements(tile, "MapBuilderScene")


func _ready():
	if !tile.impl:
		return

	impl = tile.impl.get_or_create_mixin(ItemHolder)
	impl.item_placed.connect(_item_placed)
	impl.item_removed.connect(_item_removed)


func _item_placed(item: Item):
	_item_node = map_builder.get_item_node(item)
	if !_item_node.get_parent():
		tile.add_child(_item_node)

	if _item_node.get_parent() != tile:
		_item_node.reparent(tile, false)

	_item_node.position.y = 0.05
	_item_node.rotation.x = deg_to_rad(-90)


func _item_removed(_item: Item):
	if !_item_node:
		return
	tile.remove_child(_item_node)


func _exit_tree():
	if impl:
		impl.item_placed.disconnect(_item_placed)
