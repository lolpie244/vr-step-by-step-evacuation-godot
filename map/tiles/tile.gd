extends Node

class_name Tile

enum Type {
	None,
	Floor,
	Wall,
	Door,
	Window,
	Staircase,
}

@export var type: Type
@export var is_walkable: bool

@export var model: MeshInstance3D
@export var substitute_model: MeshInstance3D


func _get_configuration_warning():
	if not model:
		return "Model is not set"
	return ""


func _get_scale(model_arg: MeshInstance3D, tile: TileOnMap) -> Vector3:
	var scale = tile.size / max(model_arg.get_aabb().size.x, model_arg.get_aabb().size.z)
	return Vector3(scale, scale, scale)


func _get_position(model_arg: MeshInstance3D, tile: TileOnMap) -> Vector3:
	return model_arg.position * _get_scale(model_arg, tile)


func _get_mesh_for_tile(model_arg: MeshInstance3D, tile: TileOnMap) -> VisualInstance3D:
	var result := model_arg.duplicate() as MeshInstance3D
	result.visible = true

	result.scale = _get_scale(model_arg, tile)
	result.position = _get_position(model_arg, tile)

	return result


func get_mesh(tile: TileOnMap) -> VisualInstance3D:
	return _get_mesh_for_tile(model, tile)
