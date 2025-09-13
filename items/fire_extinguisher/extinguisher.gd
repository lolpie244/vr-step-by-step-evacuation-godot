@tool
extends Node3D

signal strength_changed(strength: float)

@onready var lever_pickup: XRToolsPickable = $LeverOrigin/LeverPickup
@onready var hose_end: HoseEnd = $HoseEndOrigin/HoseEnd


var is_pin_released: bool = false

var strength: float:
	set(value):
		if not is_pin_released:
			print("ERROR")
			return

		strength = clamp(value, 0, 1)
		strength_changed.emit(strength)


func release_pin():
	if is_pin_released:
		print("Pin already released")
		return

	is_pin_released = true
	$AnimationPlayer.play("release_pin")


func _on_lever_pickup_picked_up(pickable: Variant) -> void:
	hose_end.enabled = true


func _on_lever_pickup_dropped(pickable: Variant) -> void:
	hose_end.enabled = false
