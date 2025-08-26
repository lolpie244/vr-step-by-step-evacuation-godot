extends Node3D

@onready var map: Map = $Map
@onready var grid: MapGrid = $Map/Grid

var character


func _ready() -> void:
	character = map.add_character(CharacterFactory.Type.Civilian, 1, 1)

	character.highlight_tiles(true)


func _input(_event: InputEvent):
	var x = character._x
	var y = character._y

	if Input.is_action_just_pressed("right"):
		map.move_character(character, x + 1, y)

	if Input.is_action_just_pressed("left"):
		map.move_character(character, x - 1, y)

	if Input.is_action_just_pressed("up"):
		map.move_character(character, x, y - 1)

	if Input.is_action_just_pressed("down"):
		map.move_character(character, x, y + 1)
