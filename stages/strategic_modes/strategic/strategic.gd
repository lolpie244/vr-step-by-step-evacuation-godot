class_name StrategicScene
extends MapScene
const IMPLEMENTS := "StrategicScene"


class Context:
	var character_count: int

	func _init(_character_count: int):
		self.character_count = _character_count


@export var next_scene: PackedScene
@export var rope_trigger: PackedScene

var context: Context
var first_mode_trigger: RopeTrigger

@onready var saved_characters_shelf: MultiMesh = $SavedCharacters.multimesh
@onready var dead_characters_shelf: MultiMesh = $DeadCharacters.multimesh


func _fill_shelf_multimesh(multimesh: MultiMesh, number: int):
	multimesh.instance_count = number
	multimesh.visible_instance_count = 0
	for i in range(number):
		var mesh_transform := Transform3D.IDENTITY
		mesh_transform.origin = Vector3(1 * i, 0, 0)
		multimesh.set_instance_transform(i, mesh_transform)


func _add_first_mode_trigger():
	if first_mode_trigger:
		self.remove_child(first_mode_trigger)
		first_mode_trigger.free()

	first_mode_trigger = rope_trigger.instantiate()
	add_child(first_mode_trigger)
	first_mode_trigger.global_position = $RopeTriggerOrigin.global_position
	first_mode_trigger.triggerred.connect(_on_first_mode_trigger_triggerred)


func _add_characters(number: int = 1, burning_tile: Tile = null):
	var walkable_tiles: Array[Tile] = []

	for x in range(map.impl.rows_count()):
		for y in range(map.impl.columns_count()):
			var tile = map.impl.get_tile(x, y)
			if Walkable.is_walkable(tile):
				walkable_tiles.append(tile)

	number = min(walkable_tiles.size(), number)

	for i in range(number):
		var id = randi_range(0, walkable_tiles.size() - 1)
		var tile := walkable_tiles[id]
		map.add_character(Character.Type.CIVILIAN, tile.pos)
		walkable_tiles.remove_at(id)

	for character in map.impl.characters:
		character.death.connect(_on_character_death)
		character.saved.connect(_on_character_saved)

	if !burning_tile:
		return

	var character := map.impl.characters[0]
	var visible_from_burning := ShadowCasting.visible_tiles(burning_tile).filter(
		func(tile): return Walkable.is_walkable(tile)
	)
	var id = randi_range(0, visible_from_burning.size() - 1)
	character._walkable = null
	character.place(visible_from_burning[id])
	character.enabled = true


func _add_flames(number: int = 1) -> Array[Tile]:
	var items: Array[Item] = map.impl.items.filter(
		func(item: Item): return item is Furniture and item.main_tile() != null
	)

	number = min(items.size(), number)
	var burning_tiles: Array[Tile] = []

	for i in range(number):
		var id = randi_range(0, items.size() - 1)
		var item := items[id]
		item.main_tile().get_mixin(Flammable).ignite()
		burning_tiles.append(item.main_tile())
		items.remove_at(id)

	return burning_tiles


func _ready() -> void:
	_add_first_mode_trigger()
	GameCore.character_selected.connect(_on_character_selected)

	var burning_tile := _add_flames(1)[0]
	_add_characters(context.character_count, burning_tile)
	map.impl.characters[0].enabled = true

	_fill_shelf_multimesh(saved_characters_shelf, context.character_count)
	_fill_shelf_multimesh(dead_characters_shelf, context.character_count)
	GameCore.next_turn()


func _on_first_mode_trigger_triggerred() -> void:
	if !GameCore.selected_character:
		return

	first_mode_trigger.rope_item.drop()

	var character := GameCore.selected_character
	GameCore.selected_character = null
	var first_person_context := FirstPersonScene.Context.new(character)
	SceneManager.load_scene(next_scene, first_person_context)


func _on_character_selected(character: Character) -> void:
	first_mode_trigger.set_state(character != null)


func _enter_scene():
	_add_first_mode_trigger()


func _on_character_saved(_character: Character):
	saved_characters_shelf.visible_instance_count += 1


func _on_character_death(_character: Character):
	dead_characters_shelf.visible_instance_count += 1
