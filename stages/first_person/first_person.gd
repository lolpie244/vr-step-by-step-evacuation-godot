extends Node3D

class_name FirstPerson


class Context:
	var character: Character

	func _init(character_: Character):
		self.character = character_


var context: Context


func _ready() -> void:
	assert(context != null)

	for tile_ in ShadowCasting.visible_tiles(context.character.get_tile()):
		var tile = tile_.duplicate()
		tile.tile_scale(2)

		self.add_child(tile)

	context.character.hide()
	var character_tile = context.character.get_tile().duplicate()
	character_tile.tile_scale(1)
	self.add_child(character_tile)
	context.character.show()


	# $Camera.position = character_tile.get_mixin(Wallkable).position + 2
	$Camera.rotation_degrees = context.character.rotation_degrees
	$Camera.position = character_tile.position
	$Camera.position.y += 0.5
