class_name XRAnchor
extends Node3D

const LABEL_TO_TYPE := {
	"floor": Tile.Type.FLOOR,
	"wall_face": Tile.Type.WALL,
	 "door_frame": Tile.Type.DOOR,
	 "window_frame": Tile.Type.WINDOW,
}

signal initialized

var type: Tile.Type = Tile.Type.NONE
var label := ""
var mesh_instance: MeshInstance3D
var points: Array[Vector2] = []
var is_initialized: bool = false

var _draw: bool = false

var valid: bool:
	get():
		return type != Tile.Type.NONE

var left_corner := Vector2(1000, 1000)
var right_corner := Vector2(-1000, -1000)

var size: Vector2:
	get():
		return right_corner - left_corner


func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	label = entity.get_semantic_labels()[0]
	type = LABEL_TO_TYPE.get(label, Tile.Type.NONE)

	if !valid:
		return

	mesh_instance = entity.create_mesh_instance()
	add_child(mesh_instance)

var color = Color(randf(), randf(), randf())
func _process(delta: float) -> void:
	if !valid:
		return
	if !is_initialized:
		var aabb: AABB = mesh_instance.mesh.get_aabb()
		points = []
		for i in range(8):
			var point: Vector3 = mesh_instance.to_global(aabb.get_endpoint(i))
			points.append(Vector2(point.x, point.z))
		
		print("=========", label, "==========")
		print("BEFORE ROTATE")
		var str := "polygon("
		for point in points:
			str += "{0}|{1} ".format([point.x, point.y])
		print(str, ")")
		
		var angles := Vector2(
			_get_rotation(points, Utils.Axis.X),
			_get_rotation(points, Utils.Axis.Y)
		)
		var angle := angles.x
		print(angles)
		
		if abs(angles.x) > abs(angles.y):
			print("hihi")
			angle = angles.y
		
		for i in range(points.size()):
			points[i] = points[i].rotated(angle)
			left_corner = Vector2(
				min(left_corner.x, points[i].x),
				min(left_corner.y, points[i].y)
			)
			right_corner = Vector2(
				max(right_corner.x, points[i].x),
				max(right_corner.y, points[i].y)
			)
		
		
		#if type == Tile.Type.FLOOR:
		print("AFTER ROTATE")
		str = "polygon("
		for point in points:
			str += "{0}|{1} ".format([point.x, point.y])
		print(str, ")")
	
		is_initialized = true
		initialized.emit()
	
	if _draw:
		var l := Vector3(left_corner.x, -2, left_corner.y)
		var r := Vector3(right_corner.x, -2, right_corner.y)
		#DebugDraw3D.draw_line(Vector3(0, 0, 0), Vector3(1, 0, 0))	
		#DebugDraw3D.draw_line(Vector3(0, 0, 0), Vector3(0, 0, 1))
		var points_to_draw = []
		for point in points:
			points_to_draw.append(Vector3(point.x, -2, point.y))
		DebugDraw3D.draw_points(points_to_draw, 0, 0.1, color)
		#DebugDraw3D.draw_points([l, r], 0, 0.1, color + Color.RED)


func _get_rotation(points: Array[Vector2], axis: Utils.Axis) -> float:
	var angle_to: Vector2
	
	if axis == Utils.Axis.X:
		angle_to = Vector2(0, 1)
		points.sort()
	
	if axis == Utils.Axis.Y:
		angle_to = Vector2(1, 0)
		points.sort_custom(func(a, b): return a.y < b.y)

	for i in range(1, points.size()):
		if snapped(points[i][axis], 0.01) != snapped(points[i - 1][axis], 0.01):
			print(points[i], ' ', points[i - 1])
			var vector := (points[i] - points[i - 1]).normalized()
			var res1 = vector.angle_to(angle_to)
			var res2 = vector.angle_to(-1 * angle_to)
			
			if abs(res1) < abs(res2):
				return res1
			return res2

	return 0
