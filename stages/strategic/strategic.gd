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

	var character_count := 1

	var walkable_tiles: Array[Tile] = []

	for x in range(map.impl.rows_count()):
		for y in range(map.impl.columns_count()):
			var tile = map.impl.get_tile(x, y)
			if Walkable.is_walkable(tile):
				walkable_tiles.append(tile)

	character_count = min(walkable_tiles.size(), character_count)

	for i in range(character_count):
		var id = randi_range(0, walkable_tiles.size() - 1)
		var tile := walkable_tiles[id]
		map.add_character(Character.Type.CIVILIAN, tile.pos)
		walkable_tiles.remove_at(id)

	GameCore.next_turn()


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
