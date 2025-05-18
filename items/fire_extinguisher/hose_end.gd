extends RigidBody3D

@onready var particles: GPUParticles3D = $GPUParticles3D


func _on_extinguisher_strength_changed(strength:float) -> void:
	if strength == 0:
		particles.emitting = false
		return

	particles.emitting = true
	particles.amount_ratio = strength

