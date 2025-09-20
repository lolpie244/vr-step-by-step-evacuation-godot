extends Node3D

@export var next_scene: PackedScene
@export var rope_trigger: PackedScene

var first_mode_trigger: RopeTrigger

@onready var map: Map = $Map
@onready var scale_lever: Lever = $ScaleLever
@onready var offset_joystick: Joystick = $OffsetJoystick


func _add_first_mode_trigger():
	if first_mode_trigger:
		self.remove_child(first_mode_trigger)
		first_mode_trigger.free()

	first_mode_trigger = rope_trigger.instantiate()
	add_child(first_mode_trigger)
	first_mode_trigger.global_position = $RopeTriggerOrigin.global_position
	first_mode_trigger.triggerred.connect(_on_first_mode_trigger_triggerred)


func _ready() -> void:
	_add_first_mode_trigger()

	map.add_character(Character.Type.CIVILIAN, 6, 4)
	map.add_character(Character.Type.CIVILIAN, 2, 4)
	GameCore.grid.get_tile_mixin(9, 1, Flammable).ignite()
	GameCore.next_turn()
	#GameCore.grid.get_tile_mixin(9, 2, Flammable).ignite()


func _on_zoom_lever_moved(_angle: Variant) -> void:
	map.zoom += -0.02 * scale_lever.fill_ratio


func _on_offset_joystick_moved(_angle: Vector2) -> void:
	map.offset += 0.003 * offset_joystick.fill_ratio


func _on_button_released(_button: Variant) -> void:
	GameCore.next_turn()


func _on_first_mode_trigger_triggerred() -> void:
	if !map.selected_character:
		return

	first_mode_trigger.rope_item.drop()

	var character := map.selected_character.impl
	character.select(false, false)
	var context := FirstPerson.Context.new(character)
	SceneManager.load_scene(next_scene, context)


func _on_map_character_selected(character_node: CharacterStrategic) -> void:
	first_mode_trigger.set_state(character_node != null)


func _enter_scene():
	_add_first_mode_trigger()
	#first_mode_trigger.get_node("Rope")._ready()
	#first_mode_trigger.reset()
	#self.remove_child(first_mode_trigger)
	#first_mode_trigger.free()
	#first_mode_trigger = base_first_mode_trigger.duplicate(Utils.DEFAULT_DUPLICATE)
	#self.add_child(first_mode_trigger)
