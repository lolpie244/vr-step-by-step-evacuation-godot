extends Node3D

@onready var rope_item: RigidBody3D = $Rope.attached_to_end

func _on_rope_max_extend(end_position: Vector3) -> void:
	if (rope_item.global_position - end_position).length() < 0.2:
		rope_item.global_position = end_position
		return

	$Rope.drop_end()
