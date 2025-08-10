extends Node

var _stage_stack: Array[PackedScene]
var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(scene: PackedScene):
	assert(scene != null)
	_stage_stack.push_back(scene)
	call_deferred("_deferred_load_scene", scene)

func _deferred_load_scene(scene: PackedScene):
	current_scene.free()
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func pop_scene():
	_stage_stack.pop_back()
	if _stage_stack.size():
		load_scene(_stage_stack.back())
