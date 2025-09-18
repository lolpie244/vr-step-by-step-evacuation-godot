class_name FirstPerson
extends Node3D


class Context:
	var character: Character

	func _init(_character: Character):
		self.character = _character


var context: Context

@onready var factory: FirstPersonTileFactory = $Factory


func _ready() -> void:
	$PlayerVr.open_eyes()

	for tile in ShadowCasting.visible_tiles(context.character.get_tile()):
		self.add_child(factory.create(tile))

	var character_tile = factory.create(context.character.get_tile())
	self.add_child(character_tile)

	# $PlayerVr.rotation_degrees = context.character.rotation_degrees
	$PlayerVr.position.x = character_tile.position.x
	$PlayerVr.position.z = character_tile.position.z

	$ItemDropper.position = $PlayerVr.position
	$ItemDropper.position.x += 0.6

	$ItemDropper.spawn()
