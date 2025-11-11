class_name XRAnchor
extends Node3D

signal initialized

var is_initialized: bool = false

var left_corner := Vector2(1000, 1000)
var right_corner := Vector2(-1000, -1000)

var size: Vector2:
	get():
		return right_corner - left_corner

var _type
var _label := ""
var _points: Array[Vector2] = []
var _mesh_points: Array[Vector3] = []


func is_valid():
	return _type != null


func get_type():
	return _type


func set_label(label: String):
	_label = label


func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	set_label(entity.get_semantic_labels()[0])

	if !is_valid():
		return

	var mesh_instance = entity.create_mesh_instance()
	add_child(mesh_instance)

	var aabb: AABB = mesh_instance.mesh.get_aabb()
	_mesh_points = []
	for i in range(8):
		_mesh_points.append(self.to_local(mesh_instance.to_global(aabb.get_endpoint(i))))

	remove_child(mesh_instance)


func _process(_delta: float) -> void:
	if !is_valid() || is_initialized:
		return

	_points = []
	for point in _mesh_points:
		point = self.to_global(point)
		_points.append(Vector2(point.x, point.z))

	var angles := Vector2(
		_get_rotation(_points, Utils.Axis.X), _get_rotation(_points, Utils.Axis.Y)
	)
	var angle := angles.x
	if abs(angles.x) > abs(angles.y):
		angle = angles.y

	for i in range(_points.size()):
		_points[i] = _points[i].rotated(angle)
		left_corner = Vector2(min(left_corner.x, _points[i].x), min(left_corner.y, _points[i].y))
		right_corner = Vector2(max(right_corner.x, _points[i].x), max(right_corner.y, _points[i].y))

	init()
	is_initialized = true
	initialized.emit()


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
			var vector := (points[i] - points[i - 1]).normalized()
			var res1 = vector.angle_to(angle_to)
			var res2 = vector.angle_to(-angle_to)

			if abs(res1) < abs(res2):
				return res1
			return res2

	return 0


func init():
	pass
