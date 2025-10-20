class_name SpawnPointGenerator
extends Node3D

@export var radius: float
@export var angle_between: float

var points_count := 0:
	set(val):
		points_count = val
		if points_count % 2 == 0:
			_start_angle = angle_between / 2.0 - (points_count / 2.0) * angle_between
		else:
			_start_angle = -floor(points_count / 2.0) * angle_between

var _start_angle := 0.0
var _current := 0


func get_point() -> Vector3:
	if _current >= points_count:
		_current = 0

	var point_position := (position - Vector3(0, 0, radius)).rotated(
		Vector3(0, 1, 0), deg_to_rad(_start_angle + angle_between * _current) 
	)

	_current += 1
	return to_global(point_position)


func reset():
	_current = 0
