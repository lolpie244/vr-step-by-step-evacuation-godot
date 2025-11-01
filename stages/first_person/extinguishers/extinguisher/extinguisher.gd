class_name ExtinguisherNode
extends Node3D

signal initialized

const IMPLEMENTS := "ExtinguisherNode"

@export var type: Extinguisher.Type

var impl: Extinguisher
var enabled: bool = true:
	set(val):
		enabled = val
		handle_pickup.enabled = enabled
		pin_pickup.enabled = enabled

@onready var body: XRToolsPickable = $Body
@onready var hose_end: HoseEndNode = $HoseEndOrigin
@onready var hose_end_pickup: XRToolsPickable = $HoseEndOrigin/Pickup
@onready var handle_pickup: XRToolsPickable = $HandleOrigin/Pickup
@onready var pin_pickup: XRToolsPickable = $Body/PinOrigin/Pickup


func _ready() -> void:
	hose_end_pickup.enabled = false


func set_impl(_impl: Extinguisher):
	impl = _impl
	initialized.emit()


func _process(delta):
	if impl:
		impl._process(delta)


func _on_handle_picked_up(_pickable: Variant) -> void:
	hose_end_pickup.enabled = hose_end.is_pickable
	body.drop()


func _on_handle_dropped(_pickable: Variant) -> void:
	hose_end_pickup.drop()
	hose_end_pickup.enabled = false
