class_name XRAnchor
extends Node3D

const LABEL_TO_TYPE := {
	"floor": Tile.Type.FLOOR,
	"wall_face": Tile.Type.WALL,
	 "door_frame": Tile.Type.DOOR,
	# "window_frame": Tile.Type.WINDOW,
}

var type: Tile.Type = Tile.Type.NONE
var label := ""
#var aabb: AABB
var mesh_instance: MeshInstance3D

var valid: bool:
	get():
		return type != Tile.Type.NONE

var aabb: AABB:
	get():
		return mesh_instance.global_transform * mesh_instance.get_aabb()
		
var left_corner: Vector2:
	get():
		return Vector2(aabb.position.x, aabb.position.z)

var right_corner: Vector2:
	get():
		return left_corner + size

var size: Vector2:
	get():
		if mesh_instance.mesh is PlaneMesh && type != Tile.Type.FLOOR:
			if aabb.size.x < aabb.size.z:
				return Vector2(0.1, aabb.size.z)
			else:
				return Vector2(aabb.size.x, 0.1)
		return Vector2(aabb.size.x, aabb.size.z)


func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	label = entity.get_semantic_labels()[0]
	type = LABEL_TO_TYPE.get(label, Tile.Type.NONE)

	if !valid:
		return
	
	mesh_instance = entity.create_mesh_instance()
	add_child(mesh_instance)

	#(func():
		#entity.untrack()
	#).call_deferred()
