extends Node3D

@onready var map: Map = $Map
@onready var grid: MapGrid = $Map/Grid
@onready var scale_lever: Lever = $ScaleLever
@onready var offset_joystick: Joystick = $OffsetJoystick

@export var next_scene: PackedScene

var character


func _ready() -> void:
	# character = map.add_character(CharacterFactory.Type.Civilian, 8, 1)

	# character.highlight_reachable(true)

	# character.visible_tiles()
	grid.get_tile_mixin(9, 1, FlammableImpl).ignite()

	# var context := FirstPerson.Context.new(character)
	# SceneManager.load_scene(next_scene, context)

	# spread_fun_timer()


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

func _on_zoom_lever_moved(_angle: Variant) -> void:
	map.zoom += -0.02 * scale_lever.fill_ratio


func _on_offset_joystick_moved(_angle: Vector2) -> void:
	map.offset += 0.003 * offset_joystick.fill_ratio


func _on_button_released(_button: Variant) -> void:
	await $PlayerVr.close_eyes()
	print("Change scene")
	#var context := FirstPerson.Context.new(character)
	var context = null
	SceneManager.load_scene(next_scene, context)
