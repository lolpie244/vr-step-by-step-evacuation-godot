extends Node

var impl: ItemHolder

@onready var tile: Tile2D = get_parent()
@onready
var map_builder: MapBuilderScene = Utils.find_parent_that_implements(tile, "MapBuilderScene")


func _ready():
	if !tile.impl:
		return

	impl = tile.impl.get_or_create_mixin(ItemHolder)
	impl.item_placed.connect(_item_placed)


func _item_placed(item: Item):
	var item_node := map_builder.get_item_node(item)
	if !item_node.get_parent():
		tile.add_child(item_node)

	if item_node.get_parent() != tile:
		item_node.reparent(tile, false)

	item_node.position.y = 0.05
	item_node.rotation.x = deg_to_rad(-90)


func _exit_tree():
	if impl:
		impl.item_placed.disconnect(_item_placed)
