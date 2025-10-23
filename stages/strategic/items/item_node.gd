@tool
class_name ItemNode
extends Node3D

@export var type: String
@export var mesh_instance: PackedScene
@export var size: Vector2i = Vector2.ONE

var _impl


func _ready() -> void:
	$Model.add_child(mesh_instance.instantiate())
	if !Engine.is_editor_hint():
		hide()

	if !impl():
		return

	impl().placed.connect(_on_placed)


func set_data(new_impl):
	_impl = new_impl


func impl() -> Item:
	return _impl


func _on_placed(_tile: Tile):
	print("SHOW")
	show()
