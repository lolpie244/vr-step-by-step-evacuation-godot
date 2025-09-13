extends Node

class_name Sync

var offset: Transform3D
var target: Node3D
var source: Node3D
var condition: Callable
var default_freeze: bool
var support_freeze: bool = false

var _previous_do_sync: bool

var _default_condition = func(_target, _source):
	return true

func _init(target_: Node3D, source_: Node3D, condition_: Callable = _default_condition):
	target = target_
	source = source_
	condition = condition_
	if "freeze" in target:
		default_freeze = target.freeze
		support_freeze = true
	offset = source.global_transform.affine_inverse() * target.global_transform

func sync():
	var do_sync: bool = condition.call(target, source)

	if do_sync:
		if support_freeze:
			target.freeze = true
		target.global_transform = source.global_transform * offset
	else:
		if do_sync != _previous_do_sync && support_freeze:
			target.freeze = default_freeze

	_previous_do_sync = do_sync
