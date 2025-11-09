@tool
class_name HoseEndNode
extends Node3D

@export var is_pickable: bool = false

var _last_hand_transform: Transform3D

@onready var pickup: XRToolsPickable = $Pickup
@onready var particles: GPUParticles3D = $Pickup/GPUParticles3D
@onready var emiting_area: Area3D = $Pickup/Area3D

@onready var impl: Extinguisher = Utils.find_parent_that_implements(self, "ExtinguisherNode").impl


func _ready():
	if !impl:
		return

	impl.foam_strength_changed.connect(_on_strength_changed)


func _on_strength_changed(strength: float) -> void:
	if strength == 0:
		particles.emitting = false
		return

	particles.emitting = true
	particles.amount_ratio = strength


func _process(_delta):
	if !impl || Engine.is_editor_hint():
		return

	if is_pickable:
		if !pickup.is_picked_up():
			return
		_last_hand_transform = pickup._grab_driver.primary.hand.global_transform

	if impl.foam_strength != 0:
		for area in emiting_area.get_overlapping_areas():
			if area.has_method("extinguish"):
				area.extinguish(impl)
