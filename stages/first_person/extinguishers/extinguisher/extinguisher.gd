class_name ExtinguisherNode
extends Node3D

@export var type: Extinguisher.Type

var impl: Extinguisher

@onready var body: XRToolsPickable = $Body
@onready var hose_end: HoseEndNode = $HoseEndOrigin/Pickup


func set_data(_impl: Extinguisher):
	impl = _impl


func _process(delta):
	impl._process(delta)


func _on_handle_picked_up(_pickable: Variant) -> void:
	hose_end.enabled = hose_end.is_pickable
	body.drop()


func _on_handle_dropped(_pickable: Variant) -> void:
	hose_end.drop()
	hose_end.enabled = false
