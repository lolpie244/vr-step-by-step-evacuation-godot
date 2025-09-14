@tool
extends Node3D
class_name Extinguisher

signal pin_released

@onready var lever_pickup: XRToolsPickable = $LeverOrigin/LeverPickup
@onready var body: XRToolsPickable = $Body
@onready var hose_end: HoseEnd = $HoseEndOrigin/HoseEnd

@onready var pin: ExtinguisherPin = $Body/PinOrigin
@onready var handle: ExtinguisherHandle = $HandleOrigin

var is_pin_released: bool:
	get():
		return pin.is_pin_released

var strength: float:
	get():
		return handle.strength


func _on_lever_pickup_picked_up(_pickable: Variant) -> void:
	hose_end.enabled = true
	body.drop()


func _on_lever_pickup_dropped(_pickable: Variant) -> void:
	hose_end.drop()
	hose_end.enabled = false
