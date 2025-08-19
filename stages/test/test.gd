extends Node3D

@onready var grid = $Map

var character

func _ready() -> void:
	character = grid.add_character(CharacterFactory.Type.Civilian, 1, 1)


func _input(_event: InputEvent):
	var x = character.x
	var y = character.y

	if Input.is_action_just_pressed("right"):
		grid.move_character(character, x + 1, y)

	if Input.is_action_just_pressed("left"):
		grid.move_character(character, x - 1, y)

	if Input.is_action_just_pressed("up"):
		grid.move_character(character, x, y - 1)

	if Input.is_action_just_pressed("down"):
		grid.move_character(character, x, y + 1)
