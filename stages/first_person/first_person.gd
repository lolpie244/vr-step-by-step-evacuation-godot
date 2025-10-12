class_name FirstPerson
extends Node3D

const TILE_SIZE := 2.0


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


var context: Context
var grid := GameCore.grid

@onready var factory: FirstPersonTileFactory = $Factory
@onready var player: PlayerVR = $PlayerVR


func _add_child_node(tile: TileNode):
	self.add_child(tile)
	tile.init()
	var tile_pos := tile.impl.pos
	tile.position = grid.tile_position(TILE_SIZE, tile_pos.x, tile_pos.y)
	tile.scale = Vector3.ONE * grid.model_scale(TILE_SIZE, tile)


func _ready() -> void:
	for tile in context.character.visible_tiles():
		_add_child_node(factory.create(tile))

	var character_tile = factory.create(context.character.get_tile())
	_add_child_node(character_tile)

	player.rotate_y(context.character._look_direction.angle() - deg_to_rad(180))

	player.position.x = character_tile.position.x
	player.position.z = character_tile.position.z

	$ItemDropper.global_position = player.global_position
	$ItemDropper.position.x += 0.6

	$ExitTrigger.global_position = player.global_position
	$ExitTrigger.position.x -= 0.4

	$ItemDropper.spawn()
	$ExitTrigger.spawn()


func _on_exit_trigger_triggerred() -> void:
	var player_rotation = player.camera.rotation.y
	context.character._look_direction = Vector2(cos(player_rotation), sin(player_rotation))
	SceneManager.pop_scene()
