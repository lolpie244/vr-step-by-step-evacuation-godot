class_name FirstPerson
extends Node3D


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


var context: Context

@onready var factory: FirstPersonTileFactory = $Factory


func _ready() -> void:
	for tile in context.character.visible_tiles():
		self.add_child(factory.create(tile))

	var character_tile = factory.create(context.character.get_tile())
	self.add_child(character_tile)

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
