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

const WALL_LIKE_TYPES = [Type.Wall, Type.Door, Type.Window]

@export var type: Type
@export var is_walkable: bool

@export var model: MeshInstance3D
@export var substitute_model: MeshInstance3D


func _get_configuration_warning():
	if not model:
		return "Model is not set"
	return ""


func _get_mesh_for_tile(model_arg: MeshInstance3D, tile: TileOnGrid) -> VisualInstance3D:
	var result := model_arg.duplicate() as MeshInstance3D
	result.visible = true

	result.scale = Vector3.ONE * tile.grid.model_scale(model_arg)
	result.position = model_arg.position * result.scale

	return result


func get_mesh(tile: TileOnGrid) -> VisualInstance3D:
	return _get_mesh_for_tile(model, tile)
