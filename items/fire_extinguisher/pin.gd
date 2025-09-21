class_name ExtinguisherPin
extends Node3D

var is_pin_released: bool = false

@onready var pickup: XRToolsPickable = $PinPickable
@onready var mesh = $PinMesh


func _process(_delta):
	if is_pin_released || !pickup.is_picked_up():
		return

	var pickup_pos_local := global_transform.affine_inverse() * pickup.global_position
	var pullback: float = max(0.0, -pickup_pos_local.x)

	if pullback < 0.05:
		mesh.position = Vector3(-pullback, 0, 0)
	else:
		call_deferred("release_pin")


func release_pin():
	is_pin_released = true
	mesh.reparent(pickup, false)
	mesh.position = Vector3.ZERO


func _on_pin_pickable_dropped(_pickable: Variant) -> void:
	if is_pin_released:
		self.top_level = true
		pickup.freeze = false
		pickup.enabled = false
