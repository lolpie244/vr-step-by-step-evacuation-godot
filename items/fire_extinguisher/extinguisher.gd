@tool
extends Node3D
class_name Extinguisher

signal strength_changed(strength: float)

@onready var lever_pickup: XRToolsPickable = $LeverOrigin/LeverPickup
@onready var body: XRToolsPickable = $Body
@onready var hose_end: HoseEnd = $HoseEndOrigin/HoseEnd
@onready var pin_origin: Node3D = $Body/PinOrigin
@onready var pin_pickup: XRToolsPickable = $Body/PinOrigin/PinPickable
@onready var pin_mesh = $Body/PinOrigin/PinMesh

var is_pin_released: bool = false

var strength: float:
	set(value):
		if not is_pin_released:
			print("ERROR")
			return

		strength = clamp(value, 0, 1)
		strength_changed.emit(strength)


# func release_pin():
# 	if is_pin_released:
# 		print("Pin already released")
# 		return
#
# 	is_pin_released = true
# 	$AnimationPlayer.play("release_pin")


func _on_lever_pickup_picked_up(_pickable: Variant) -> void:
	hose_end.enabled = true
	body.drop()


func _on_lever_pickup_dropped(_pickable: Variant) -> void:
	hose_end.drop()
	hose_end.enabled = false

func _process(_delta):		
	if !is_pin_released && pin_pickup.is_picked_up():
		var pickup_pos_local := pin_origin.global_transform.affine_inverse() * pin_pickup.global_position

		var pullback: float = max(0.0, -pickup_pos_local.x)

		if pullback < 0.5:
			pin_mesh.position = Vector3(-pullback, 0, 0)
		else:
			is_pin_released = true
