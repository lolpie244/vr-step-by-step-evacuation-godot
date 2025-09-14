extends Node3D
class_name ExtinguisherHandle

signal strength_changed(strength: float)

@onready var extinguisher: Extinguisher = get_owner()
@onready var pickup: XRToolsPickable = $HandlePickup
@onready var mesh = $HandlePickup/Mesh

const start_rotation: float = 0;
const end_rotation: float = 27;


var strength: float

func _strength_changed(button: String, value: float) -> void:
	if button != "trigger" || !pickup.is_picked_up() || !extinguisher.is_pin_released:
		return

	strength = value
	mesh.rotation_degrees.x = -((end_rotation - start_rotation) * strength + start_rotation)

	strength_changed.emit(strength)


func _on_handle_pickup_grabbed(_pickable: Variant, by: Variant) -> void:
	var action_signal = by._controller.input_float_changed
	
	if not action_signal.is_connected(_strength_changed):
		action_signal.connect(_strength_changed)


func _on_handle_pickup_released(_pickable: Variant, by: Variant) -> void:
	by._controller.input_float_changed.disconnect(_strength_changed)
