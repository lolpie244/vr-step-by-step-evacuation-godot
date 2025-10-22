extends MapScene

@export var next_scene: PackedScene
@export var rope_trigger: PackedScene

var first_mode_trigger: RopeTrigger


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
	GameCore.character_selected.connect(_on_character_selected)

	map.add_character(Character.Type.CIVILIAN, 6, 4)
	map.add_character(Character.Type.CIVILIAN, 2, 4)
	GameCore.grid.get_tile_mixin(9, 1, Flammable).ignite()
	GameCore.next_turn()
	map.add_furniture(Furniture.Type.BED, Vector2(1, 2), Utils.Direction.UP, 7, 2)


func _on_first_mode_trigger_triggerred() -> void:
	if !GameCore.selected_character:
		return

	first_mode_trigger.rope_item.drop()

	var character := GameCore.selected_character
	var context := FirstPerson.Context.new(character)
	SceneManager.load_scene(next_scene, context)


func _on_character_selected(character: Character) -> void:
	first_mode_trigger.set_state(character != null)


func _enter_scene():
	GameCore.selected_character = null
	_add_first_mode_trigger()
