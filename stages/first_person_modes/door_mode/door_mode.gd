class_name FirstPersonModeDoor
extends FirstPersonScene

var _door_tile: TileNode
var _character_tile: TileNode


static func _get_door_tile(character_tile: Tile) -> Tile:
	for tile in character_tile.direct_neighbor_tiles():
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
	_door_tile = tiles[_get_door_tile(context.character.get_tile())]
	_character_tile = tiles[context.character.get_tile()]
	player.position += (_door_tile.global_position - _character_tile.global_position) * 0.7

	for tile in ShadowCasting.visible_tiles(_door_tile.impl):
		if not tile in tiles:
			_add_tile_node(tile_factory.create(tile))

	look_at_tile(_door_tile)
	_door_tile.impl.get_mixin(Blockable).blocking_changed.connect(_on_door_blocking_changed)

	player.left_hand.rumble_strength = 0.3
	player.right_hand.rumble_strength = 0.3


func _on_left_hand_back_entered(_body: Node3D) -> void:
	player.left_hand.start_rumble()


func _on_left_hand_back_exited(_body: Node3D) -> void:
	player.left_hand.stop_rumble()


func _on_right_hand_back_entered(_body: Node3D) -> void:
	player.right_hand.start_rumble()


func _on_right_hand_back_exited(_body: Node3D) -> void:
	player.right_hand.stop_rumble()


func _on_door_blocking_changed(blocking: bool):
	if blocking:
		return

	for tile in _door_tile.impl.direct_neighbor_tiles():
		var flammable: Flammable = tile.get_mixin(Flammable)
		if flammable and flammable.state == Flammable.State.BURNING:
			_door_tile.impl.get_mixin(Flammable).ignite()
			_character_tile.impl.get_mixin(Flammable).ignite()
