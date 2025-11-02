class_name FurnitureXRAnchor
extends XRAnchor

const LABEL_TO_IMPL := {
	"wall_art": "",
	"couch": "",
	"table": "Furniture.TABLE",
	"bed": "Furniture.BED",
	"lamp": "",
	"plant": "",
	"screen": "",
	"storage": "",
}

var impl: Furniture


func is_valid():
	return LABEL_TO_IMPL.get(_label, "").size() != 0


func get_type() -> Furniture.Type:
	return impl.get_type()


func _size_distance(item: Item, desired_size: Vector2i):
	return item.size.distance_squared_to(desired_size)


func init():
	var size_in_tiles: Vector2i = self.size / Constants.TILE_SIZE_IN_REAL_LIFE
	var variants: Array = ItemsCollection.get_item_variants(LABEL_TO_IMPL.get(_label))

	var variant := 0
	for i in range(1, variants.size()):
		if (
			_size_distance(variants[i], size_in_tiles)
			< _size_distance(variants[variant], size_in_tiles)
		):
			variant = i

	impl = ItemsCollection.get_item(LABEL_TO_IMPL.get(_label), variant)
