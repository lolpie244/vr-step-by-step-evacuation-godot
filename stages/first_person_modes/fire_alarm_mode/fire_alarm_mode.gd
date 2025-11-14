class_name FirstPersonModeFireAlarm
extends FirstPersonScene

var _alarm_tile: TileNode
var _character_tile: TileNode


static func _get_alarm_tile(character_tile: Tile) -> Tile:
	for tile in character_tile.direct_neighbor_tiles():
		var item_holder: ItemHolder = tile.get_mixin(ItemHolder)
		if item_holder and item_holder.get_item() is FireAlarm:
			return tile
	return null


static func is_applicable(_context: Context) -> bool:
	return _get_alarm_tile(_context.character.get_tile()) != null


static func scene() -> PackedScene:
	return preload("fire_alarm_mode.tscn")


func _ready():
	super._ready()
	_alarm_tile = tiles[_get_alarm_tile(context.character.get_tile())]
	_character_tile = tiles[context.character.get_tile()]
	player.position += (_alarm_tile.global_position - _character_tile.global_position) * 0.7

	look_at_tile(_alarm_tile)
