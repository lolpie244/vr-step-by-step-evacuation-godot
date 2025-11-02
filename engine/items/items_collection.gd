extends Node

var _items: Dictionary[String, Array] = {}


func _ready():
	var list_of_items: Array[Item] = [
		Extinguisher.new(Extinguisher.Type.POWDER),
		Extinguisher.new(Extinguisher.Type.CO2),
		Extinguisher.new(Extinguisher.Type.WATER),
		Furniture.new(Furniture.Type.BED, Vector2i(1, 2)),
		Furniture.new(Furniture.Type.TABLE, Vector2i.ONE),
	]

	for item in list_of_items:
		var type := item.get_type()
		if not type in item:
			_items[type] = []

		_items[type].append(item)


func get_item_variants(type: String):
	return _items[type]


func get_item(type: String, variant: int):
	return _items[type][variant][0]
