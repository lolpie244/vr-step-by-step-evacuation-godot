class_name TileXRAnchor
extends XRAnchor

const LABEL_TO_TYPE := {
	"floor": Tile.Type.FLOOR,
	"wall_face": Tile.Type.WALL,
	"door_frame": Tile.Type.DOOR,
	"window_frame": Tile.Type.WINDOW,
}

const MULTIPLE_TILES: Array[Tile.Type] = [Tile.Type.FLOOR, Tile.Type.WALL]


func get_type() -> Tile.Type:
	return _type


func set_label(label: String):
	super.set_label(label)
	_type = LABEL_TO_TYPE.get(label, Tile.Type.NONE)
