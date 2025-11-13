class_name FurnitureXRAnchor
extends XRAnchor

const LABEL_TO_IMPL := {
	"wall_art": "Furniture.WALL_ART",
	"couch": "Furniture.COUCH",
	"table": "Furniture.TABLE",
	"bed": "Furniture.BED",
	"lamp": "Furniture.LAMP",
	"plant": "Furniture.PLANT",
	"screen": "Furniture.SCREEN",
	"storage": "Furniture.STORAGE",
}

var item: Furniture


func is_valid():
	return LABEL_TO_IMPL.get(_label, "") != ""


func get_type() -> Furniture.Type:
	return item.type


func init():
	var size_in_tiles: Vector2 = self.size / Constants.TILE_SIZE_IN_REAL_LIFE

	item = ItemsCollection.get_item_with_closest_size(
		LABEL_TO_IMPL.get(_label), size_in_tiles, true
	)
	item._direction = Utils.direction_from_angle(self.global_rotation_degrees)
