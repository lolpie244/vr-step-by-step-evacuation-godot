extends TileNode

@onready var door: Node3D = $Model/Door


func _ready():
	var blockable: Blockable = impl.get_mixin(Blockable)
	blockable.blocking_changed.connect(_blocking_changed)
	_blocking_changed(blockable.blocking)


func _blocking_changed(blocking: bool):
	if blocking:
		door.rotation_degrees.y = 90
	else:
		door.rotation_degrees.y = 0
