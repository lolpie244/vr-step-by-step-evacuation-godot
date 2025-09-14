extends Node3D

@onready var pin_pickup: XRToolsPickable = $PinPickable
@onready var pin_mesh = $PinMesh

@onready var extinguisher: Extinguisher = owner


func _process(_delta):
	if extinguisher.is_pin_released || !pin_pickup.is_picked_up():
		return

	var pickup_pos_local := global_transform.affine_inverse() * pin_pickup.global_position
	var pullback: float = max(0.0, -pickup_pos_local.x)

	if pullback < 0.05:
		pin_mesh.position = Vector3(-pullback, 0, 0)
	else:
		call_deferred("release_pin")


func release_pin():
	extinguisher.is_pin_released = true
	pin_mesh.reparent(pin_pickup, false)
	pin_mesh.position = Vector3.ZERO

func _on_pin_pickable_dropped(pickable: Variant) -> void:
	if extinguisher.is_pin_released:
		self.top_level = true
		pin_pickup.freeze = false
		pin_pickup.enabled = false
