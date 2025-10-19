extends Node3D

@export var next_scene: PackedScene

var character

var _points: Array[Vector3] = []

@onready var map: Map = $Map
@onready var grid: MapGrid = $Map/Grid
@onready var points_spawner: SpawnPointGenerator = $SpawnPointGenerator


func _ready() -> void:
	points_spawner.points_count = 3
	for i in range(points_spawner.points_count):
		_points.append(points_spawner.get_point())


func _process(_delta: float) -> void:
	DebugDraw3D.draw_points(_points)

	#$Camera3D.rotate_y(deg_to_rad(1))

#func _input(_event: InputEvent):
#var x = character._x
#var y = character._y
#
#if Input.is_action_just_pressed("right"):
#map.move_character(character, x + 1, y)
#
#if Input.is_action_just_pressed("left"):
#map.move_character(character, x - 1, y)
#
#if Input.is_action_just_pressed("up"):
#map.move_character(character, x, y - 1)
#
#if Input.is_action_just_pressed("down"):
#map.move_character(character, x, y + 1)
