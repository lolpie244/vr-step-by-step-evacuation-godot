extends Node3D

signal triggered

const MAX_PULL := 0.06
const MAX_ROTATION := 45

var _syncer: Sync

@onready var model: Node3D = $Model
@onready var pickup: XRToolsPickable = $Pickup


func _process(_delta: float) -> void:
	if !pickup.is_picked_up():
		return

	var pickup_pos := global_transform.affine_inverse() * pickup.global_position
	var pull = max(0, -pickup_pos.y)
	if pull < MAX_PULL:
		model.rotation_degrees.x = (pull / MAX_PULL) * MAX_ROTATION
	else:
		triggered.emit()

	if _syncer:
		_syncer.sync()


func _on_pickup_picked_up(_pickable: Variant) -> void:
	_syncer = Sync.new(pickup._grab_driver.primary.hand, model)


func _on_pickup_dropped(_pickable: Variant) -> void:
	model.rotation_degrees.x = 0
	pickup.transform = Transform3D()
	_syncer = null
