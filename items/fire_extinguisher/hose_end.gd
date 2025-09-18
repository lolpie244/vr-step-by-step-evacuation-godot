@tool
extends XRToolsPickable
class_name HoseEnd

@onready var particles: GPUParticles3D = $GPUParticles3D

var syncer: Sync
var _last_hand_transform: Transform3D


func _on_strength_changed(strength: float) -> void:
	if strength == 0:
		particles.emitting = false
		return

	particles.emitting = true
	particles.amount_ratio = strength


func _process(_delta):
	if Engine.is_editor_hint() || !is_picked_up():
		return

	_last_hand_transform = _grab_driver.primary.hand.global_transform


func _on_rope_max_extend(limit_position: Vector3):
	if !is_picked_up():
		return

	_grab_driver.primary.by.global_transform = _last_hand_transform
	self.global_position = limit_position
