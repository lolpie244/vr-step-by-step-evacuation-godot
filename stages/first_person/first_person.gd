class_name FirstPerson
extends Node3D

signal extinguisher_selected

const TILE_SIZE := 3.0


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


var context: Context
var grid := GameCore.grid

@onready var tile_factory: FirstPersonTileFactory = $TileFactory
@onready var extinguisher_factory: FirstPersonExtinguisherFactory = $ExtinguisherFactory
@onready var player: PlayerVR = $PlayerVR
@onready var point_generator: SpawnPointGenerator = $PlayerVR/SpawnPointGenerator


func _add_child_node(tile: TileNode):
	self.add_child(tile)
	tile.init()
	var tile_pos := tile.impl.pos
	tile.position = grid.tile_position(TILE_SIZE, tile_pos.x, tile_pos.y)
	tile.scale = Vector3.ONE * grid.model_scale(TILE_SIZE, tile)


func _ready() -> void:
	for tile in context.character.visible_tiles():
		_add_child_node(tile_factory.create(tile))

	var character_tile = tile_factory.create(context.character.get_tile())
	_add_child_node(character_tile)

	player.rotate_y(context.character._look_direction.angle() - deg_to_rad(180))

	player.position.x = character_tile.position.x
	player.position.z = character_tile.position.z

	$ExitTrigger.global_position = player.global_position
	$ExitTrigger.position.x -= 0.4
	$ExitTrigger.spawn()

	var ext_impls: Array[Extinguisher] = []

	for ext_type in [Extinguisher.Type.POWDER, Extinguisher.Type.CO2]:
		var ext_impl := Extinguisher.new()
		ext_impl.type = ext_type

		ext_impls.append(ext_impl)

	point_generator.points_count = ext_impls.size()

	for ext_impl in ext_impls:
		var point := point_generator.to_global(point_generator.get_point())
		var ext := extinguisher_factory.create(ext_impl, point)
		add_child(ext)
		ext.triggerred.connect(func(): extinguisher_selected.emit())
		extinguisher_selected.connect(ext.remove)
		ext.spawn()


func _on_exit_trigger_triggerred() -> void:
	var player_rotation = player.camera.rotation.y
	context.character._look_direction = Vector2(cos(player_rotation), sin(player_rotation))
	SceneManager.pop_scene()
