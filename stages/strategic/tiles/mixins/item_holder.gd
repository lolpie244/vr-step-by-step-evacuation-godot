class_name StrategicItemHolder
extends ItemHolderNode

@onready var map: StrategicMap = Utils.find_parent_that_implements(tile, "Map")


func _get_item_node(_item: Item) -> ItemNode:
	return map.get_item_node(_item)
