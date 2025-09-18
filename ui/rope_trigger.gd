class_name RopeTrigger
extends Node3D

signal triggerred

@onready var rope_item: XRToolsPickable = $Rope.attached_to_end


func _on_rope_max_extend(end_position: Vector3) -> void:
	if !rope_item.is_picked_up():
		return

	if (rope_item.global_position - end_position).length() < 0.1:
		rope_item.global_position = end_position
		return

	triggerred.emit()
	remove()


func spawn():
	$AnimationPlayer.play("show")


func remove():
	$AnimationPlayer.play("remove")
