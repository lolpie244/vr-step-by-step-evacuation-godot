class_name FirstPerson
extends Node3D


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


var context: Context

@onready var factory: FirstPersonTileFactory = $Factory


func _add_child_node(tile: TileNode):
	self.add_child(tile)
	tile.init()


func _ready() -> void:
	for tile in context.character.visible_tiles():
		_add_child_node(factory.create(tile))

	var character_tile = factory.create(context.character.get_tile())
	_add_child_node(character_tile)

	$PlayerVr.position.x = character_tile.position.x
	$PlayerVr.position.z = character_tile.position.z

	$ItemDropper.global_position = $PlayerVr.global_position
	$ItemDropper.position.x += 0.6

	$ExitTrigger.global_position = $PlayerVr.global_position
	$ExitTrigger.position.x -= 0.4

	$ItemDropper.spawn()
	$ExitTrigger.spawn()


func _on_exit_trigger_triggerred() -> void:
	SceneManager.pop_scene()
