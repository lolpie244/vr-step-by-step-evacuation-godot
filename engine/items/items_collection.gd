extends Node

var _items: Dictionary[String, Array] = {}


func _ready():
	var list_of_items: Array[Callable] = [
		func(): return Extinguisher.new(Extinguisher.Type.POWDER),
		func(): return Extinguisher.new(Extinguisher.Type.CO2),
		func(): return Extinguisher.new(Extinguisher.Type.WATER),
		func(): return Furniture.new(Furniture.Type.BED, Vector2i(1, 2)),
		func(): return Furniture.new(Furniture.Type.BED, Vector2i(2, 2)),
		func(): return Furniture.new(Furniture.Type.STORAGE, Vector2i(2, 1)),
		func(): return Furniture.new(Furniture.Type.COUCH, Vector2i(2, 1)),
		func(): return Furniture.new(Furniture.Type.TABLE),
		func(): return Furniture.new(Furniture.Type.LAMP),
		func(): return Furniture.new(Furniture.Type.PLANT),
	]

	for item_constructor in list_of_items:
		var item: Item = item_constructor.call()
		var type := item.get_type()
		if not type in item:
			_items[type] = []

		_items[type].append(Pair.new(item, item_constructor))


func get_item_with_exact_size(type: String, size: Vector2i) -> Item:
	for item in _items[type]:
		if item.first.size == size:
			return item.second.call()
	return null


func _size_distance(item_size: Vector2i, desired_size: Vector2i) -> float:
	return item_size.distance_squared_to(desired_size)


func get_item_with_closest_size(type: String, size: Vector2i, rotate: bool = false) -> Item:
	if _items.get(type, []).size() == 0:
		return null

	var result: Pair = _items[type][0]
	var result_distance: float = _size_distance(result.first.size, size)

	for item in _items[type]:
		var distance := _size_distance(item.first.size, size)
		var rotated_distance := _size_distance(Vector2i(item.first.size.y, item.first.size.x), size)
		if rotate and rotated_distance < distance:
			distance = rotated_distance

		if distance < result_distance:
			result = item
			result_distance = distance

	return result.second.call()
