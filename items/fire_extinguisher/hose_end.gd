@tool
class_name HoseEnd
extends XRToolsPickable

var syncer: Sync
var _last_hand_transform: Transform3D
var _strenght: float

@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var emiting_area: Area3D = $Area3D


func _on_strength_changed(strength: float) -> void:
	_strenght = strength
	if _strenght == 0:
		particles.emitting = false
		return

	particles.emitting = true
	particles.amount_ratio = _strenght


func _process(_delta):
	if Engine.is_editor_hint() || !is_picked_up():
		return

	_last_hand_transform = _grab_driver.primary.hand.global_transform

	if _strenght != 0:
		for area in emiting_area.get_overlapping_areas():
			if area.has_method("extinguish"):
				area.extinguish(_strenght)


func _on_rope_max_extend(limit_position: Vector3):
	if !is_picked_up():
		return

	_grab_driver.primary.by.global_transform = _last_hand_transform
	self.global_position = limit_position
