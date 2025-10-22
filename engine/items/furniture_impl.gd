class_name Furniture
extends Item

enum Type {
	UNKNOWN,
	BED,
	TABLE,
}

var type: Type


func get_type():
	return ".".join([&"Furniture", Type.keys()[type]])
