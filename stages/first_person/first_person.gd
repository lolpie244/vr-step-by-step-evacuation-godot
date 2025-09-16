extends Node3D

class_name FirstPerson


class Context:
	pass
	#var character: Character
#
	#func _init(character_: Character):
		#self.character = character_


var context: Context


func _get_tile(strategic_tile: Tile):
	var tile = strategic_tile._duplicate()
	tile.position.y = 0
	tile.restore_material()
	tile.remove_mixin(Walkable)
	tile.tile_scale(2)

	return tile

func _ready() -> void:
	$PlayerVr.open_eyes()

	for tile in ShadowCasting.visible_tiles(context.character.get_tile()):
		self.add_child(_get_tile(tile))

	var character_tile = _get_tile(context.character.get_tile())
	#character_tile.remove_mixin(Character)
	self.add_child(character_tile)

	$PlayerVr.rotation_degrees = context.character.rotation_degrees
	$PlayerVr.position.x = character_tile.position.x
	$PlayerVr.position.z = character_tile.position.z

	$ItemDropper.position = $PlayerVr.position
	$ItemDropper.position.x += 0.6

	$ItemDropper.spawn()
