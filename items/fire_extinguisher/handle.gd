extends MeshInstance3D

const start_rotation: float = 0;
const end_rotation: float = 27;

func _on_extinguisher_strength_changed(strength:float) -> void:
	rotation_degrees.x = (end_rotation - start_rotation) * strength + start_rotation

