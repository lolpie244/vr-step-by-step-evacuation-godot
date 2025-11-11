class_name FirstPersonModeDoor
extends FirstPersonScene


static func _get_door_tile(character_tile: Tile) -> Tile:
	for tile in character_tile.neighbor_tiles():
		if tile.pos.x != character_tile.pos.x && tile.pos.y != character_tile.pos.y:
			continue

		var blockable: Blockable = tile.get_mixin(Blockable)
		if tile.type == Tile.Type.DOOR and blockable and blockable.blocking:
			return tile
	return null


static func is_applicable(_context: Context) -> bool:
	return _get_door_tile(_context.character.get_tile()) != null


static func scene() -> PackedScene:
	return preload("door_mode.tscn")


func _ready():
	super._ready()

	var door_tile: TileNode = tiles[_get_door_tile(context.character.get_tile())]
	var character_tile: TileNode = tiles[context.character.get_tile()]
	player.position += (door_tile.global_position - character_tile.global_position) * 0.7

	player.look_at(door_tile.global_position)
	player.rotation = Vector3(0, player.rotation.y, 0)
