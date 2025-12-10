@tool
extends Dial

var grid_size = Vector2i(3, 3)
var cell_size = Vector2(0.5, 0.5)

@onready var multimesh_instance: MultiMeshInstance3D = $MultiMeshInstance3D
@onready var multimesh: MultiMesh = multimesh_instance.multimesh


func _create_multimesh():
	multimesh.instance_count = grid_size.x * grid_size.y
	for i in range(multimesh.instance_count):
		var pos = cell_size * Vector2(i % grid_size.y, i / grid_size.y)

		var mesh_transform := Transform3D.IDENTITY
		mesh_transform.origin = Vector3(pos.x, 0, pos.y)
		multimesh.set_instance_transform(i, mesh_transform)


func _ready() -> void:
	max_value = grid_size.x * grid_size.y
	_create_multimesh()
	_on_value_changed(value)


func _on_value_changed(_value: float) -> void:
	multimesh.visible_instance_count = int(value)
