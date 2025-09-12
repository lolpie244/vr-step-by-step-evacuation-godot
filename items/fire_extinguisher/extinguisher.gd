@tool
extends XRToolsPickable

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
	
var _offset
func _process(delta):
	if lever_pickup.is_picked_up():
		self.global_transform = lever_pickup.global_transform * _offset

func _on_lever_pickup_picked_up(pickable: Variant) -> void:
	hose_end.enabled = true
	_offset = $LeverOrigin.transform.inverse()
	self.freeze = true
	lever_pickup.reparent(get_tree().root, true)


func _on_lever_pickup_dropped(pickable: Variant) -> void:
	lever_pickup.reparent(self, false)
	print("STOP")
	self.freeze = false
	lever_pickup.transform = $LeverOrigin.transform
	hose_end.enabled = false
