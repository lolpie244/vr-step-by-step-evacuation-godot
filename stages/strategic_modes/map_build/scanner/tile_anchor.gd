class_name TileXRAnchor
extends XRAnchor

const LABEL_TO_TYPE := {
	"floor": Tile.Type.FLOOR,
	"wall_face": Tile.Type.WALL,
	"door_frame": Tile.Type.DOOR,
	"window_frame": Tile.Type.WINDOW,
}

const MULTIPLE_TILES: Array[Tile.Type] = [Tile.Type.FLOOR, Tile.Type.WALL]
const ITEM_HOLDER_TILES: Array[Tile.Type] = [Tile.Type.FLOOR]


func get_type() -> Tile.Type:
	return _type


func is_item_holder() -> bool:
	return _type in ITEM_HOLDER_TILES


func is_multiple_tiles() -> bool:
	return _type in MULTIPLE_TILES


func set_label(label: String):
	super.set_label(label)
	_type = LABEL_TO_TYPE.get(label, null)
