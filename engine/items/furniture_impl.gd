class_name Furniture
extends Item

enum Type {
	UNKNOWN,
	BED,
	TABLE,
}

var type: Type


func _init(_type: Type, _size: Vector2i = Vector2i.ONE):
	super._init(_size)
	type = _type


func get_type():
	return ".".join([&"Furniture", Type.keys()[type]])
