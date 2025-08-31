extends Node3D

@onready var map: Map = $Map
@onready var grid: MapGrid = $Map/Grid

var character


func _ready() -> void:
	character = map.add_character(CharacterFactory.Type.Civilian, 1, 1)

	character.highlight_tiles(true)

	grid.get_tile(9, 1).ignite()
	spread_fun_timer()


func spread_fun_timer():
	var t := Timer.new()
	t.wait_time = 5.0
	t.one_shot = false
	t.autostart = true
	add_child(t)
	t.timeout.connect(grid.spread_fire)


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
