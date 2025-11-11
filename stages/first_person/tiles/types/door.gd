extends TileNode

@onready var door: Node3D = $Model/Door


func _ready() -> void:
	if impl.get_mixin(Blockable).blocking:
		door.rotation_degrees.y = 0
	else:
		door.rotation_degrees.y = 90
