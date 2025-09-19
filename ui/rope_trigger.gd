class_name RopeTrigger
extends Node3D

signal triggerred

@export_range(0, 1) var pull_strenght := 0.1

var _was_triggered := false
var _last_position: Vector3

@onready var rope_item: XRToolsPickable = $Rope.attached_to_end


func _on_rope_max_extend(end_position: Vector3) -> void:
	_last_position = end_position
	if !rope_item.is_picked_up():
		_was_triggered = false
		return

	if (rope_item.global_position - end_position).length() < pull_strenght:
		restore_item_position()
		_was_triggered = false
		return

	if !_was_triggered:
		triggerred.emit()
		_was_triggered = true


func restore_item_position():
	if _last_position:
		rope_item.global_position = _last_position


func spawn():
	$AnimationPlayer.play("show")


func remove():
	$AnimationPlayer.play("remove")
