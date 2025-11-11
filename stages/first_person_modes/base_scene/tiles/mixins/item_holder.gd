class_name FirstPersonItemHolder
extends ItemHolderNode

@onready var scene: FirstPersonScene = Utils.find_parent_that_implements(tile, "FirstPersonScene")


func _get_item_node(_item: Item) -> ItemNode:
	return scene.items.get(_item, null)
