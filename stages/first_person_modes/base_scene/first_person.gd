class_name FirstPersonScene
extends Node3D

const TILE_SIZE := 2.2
const IMPLEMENTS := "FirstPersonScene"


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


@export var tile_factory_scene: PackedScene
@export var item_factory_scene: PackedScene

var context: Context
var grid := GameCore.grid
var tiles: Dictionary[Tile, TileNode] = {}
var items: Dictionary[Item, ItemNode] = {}

@onready var tile_factory: TileFactory = tile_factory_scene.instantiate()
@onready var item_factory: ItemFactory = item_factory_scene.instantiate()

@onready var player: PlayerVR = $PlayerVR
@onready var point_generator: SpawnPointGenerator = $PlayerVR/SpawnPointGenerator
@onready var exit_trigger: RopeTrigger = $PlayerVR/ExitTrigger


static func is_applicable(_context) -> bool:
	return true


static func scene() -> PackedScene:
	return preload("first_person.tscn")


func _add_tile_node(tile: TileNode):
	self.add_child(tile)
	tile.init()
	var tile_pos := tile.impl.pos
	tile.position = grid.tile_position(TILE_SIZE, tile_pos.x, tile_pos.y)
	tile.scale = Vector3.ONE * grid.model_scale(TILE_SIZE, tile)
	tiles[tile.impl] = tile

	var item_holder: ItemHolder = tile.impl.get_mixin(ItemHolder)
	if item_holder and item_holder.get_item() and not items.has(item_holder.get_item()):
		items[item_holder.get_item()] = null


func _ready():
	for factory in [tile_factory, item_factory]:
		self.add_child(factory)

	context.character.death.connect(_on_character_death)

	for tile in context.character.visible_tiles():
		_add_tile_node(tile_factory.create(tile))

	var character_tile = tile_factory.create(context.character.get_tile())
	_add_tile_node(character_tile)

	for item in items.keys():
		items[item] = item_factory.create(item)
		item.restore_position()

	player.rotate_y(context.character._look_direction.angle() - deg_to_rad(180))

	player.position.x = character_tile.position.x
	player.position.z = character_tile.position.z

	exit_trigger.spawn()


func look_at_tile(tile: TileNode):
	player.look_at(tile.global_position)
	player.rotation = Vector3(0, player.rotation.y, 0)


func exit() -> void:
	var player_rotation = player.camera.rotation.y
	context.character._look_direction = Vector2(cos(player_rotation), sin(player_rotation))
	SceneManager.pop_scene()


func _on_character_death(character: Character):
	if character == context.character:
		SceneManager.pop_scene()


func _on_exit_trigger_triggerred() -> void:
	exit()
