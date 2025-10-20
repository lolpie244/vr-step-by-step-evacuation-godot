class_name ExtinguisherHandle
extends Node3D

@export var start_angle: float = 0
@export var end_angle: float = 27

@onready var extinguisher: ExtinguisherNode = get_owner()
@onready var pickup: XRToolsPickable = $Pickup
@onready var mesh = $Pickup/Mesh

@onready var impl: Extinguisher = Utils.find_parent_that_implements(self, "ExtinguisherNode").impl


func _ready() -> void:
	if !impl:
		return

	impl.foam_strength_changed.connect(_on_strength_changed)


func _action_triggered(button: String, value: float) -> void:
	if button != "trigger" || !pickup.is_picked_up() || !impl.is_pin_released:
		return

	impl.foam_strength = value


func _on_strength_changed(strength: float):
	print("Adasd")
	mesh.rotation_degrees.x = -((end_angle - start_angle) * strength + start_angle)


func _on_handle_pickup_grabbed(_pickable: Variant, by: Variant) -> void:
	var action_signal = by._controller.input_float_changed

	if not action_signal.is_connected(_action_triggered):
		action_signal.connect(_action_triggered)


func _on_handle_pickup_released(_pickable: Variant, by: Variant) -> void:
	by._controller.input_float_changed.disconnect(_action_triggered)
