class_name RopeTrigger
extends Node3D

signal triggerred

@export_range(0, 1) var pull_strenght := 0.1

var enabled := false

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


func set_state(_enabled: bool):
	if _enabled == enabled:
		return
	enabled = _enabled
	if _enabled:
		$AnimationPlayer.play("show")
	else:
		$AnimationPlayer.play("remove")


func spawn():
	set_state(true)


func remove():
	set_state(false)
