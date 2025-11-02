class_name FurnitureXRAnchor
extends XRAnchor

const LABEL_TO_TYPE := {
	"wall_art": Furniture.Type.UNKNOWN,
	"couch": Furniture.Type.UNKNOWN,
	"table": Furniture.Type.TABLE,
	"bed": Furniture.Type.BED,
	"lamp": Furniture.Type.UNKNOWN,
	"plant": Furniture.Type.UNKNOWN,
	"screen": Furniture.Type.UNKNOWN,
	"storage": Furniture.Type.UNKNOWN,
}


func get_type() -> Furniture.Type:
	return _type


func set_label(label: String):
	super.set_label(label)
	_type = LABEL_TO_TYPE.get(label, Furniture.Type.UNKNOWN)
