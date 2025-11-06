extends Node3D

@export var next_scene: PackedScene

var character

@onready var map: Map = $Map


func _ready() -> void:
	map.add_furniture(Furniture.Type.BED, Vector2(1, 2), Utils.Direction.UP, 7, 2)

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
