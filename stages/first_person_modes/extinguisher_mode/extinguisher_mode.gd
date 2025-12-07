class_name FirstPersonModeExtinguisher
extends FirstPersonScene

signal extinguisher_selected

@onready var extinguisher_factory: FirstPersonExtinguisherFactory = $ExtinguisherFactory


static func _get_burning_tile(character_tile: Tile) -> Tile:
	for tile in character_tile.direct_neighbor_tiles():
		var flammable: Flammable = tile.get_mixin(Flammable)
		if flammable and flammable.state == Flammable.State.BURNING:
			return tile
	return null


static func is_applicable(_context: Context) -> bool:
	return (
		_context.character.inventory.size() != 0
		and _get_burning_tile(_context.character.get_tile()) != null
	)


static func scene() -> PackedScene:
	return preload("extinguisher_mode.tscn")


func _ready() -> void:
	super._ready()

	var ext_impls: Array[Extinguisher] = []

	for item in context.character.inventory:
		if item is Extinguisher:
			ext_impls.append(item)

	point_generator.points_count = ext_impls.size()
	var burning_tile_node := tiles[_get_burning_tile(context.character.get_tile())]
	look_at_tile(burning_tile_node)
	burning_tile_node.impl.get_mixin(Flammable).state_changed.connect(_on_flammable_state_changed)

	for ext_impl in ext_impls:
		var ext := extinguisher_factory.create(ext_impl, point_generator.get_point())
		add_child(ext)
		ext.look_at(player.global_position)
		ext.triggerred.connect(func(): extinguisher_selected.emit())
		extinguisher_selected.connect(ext.remove)
		ext.spawn()


func _on_flammable_state_changed(_flammable: Flammable, _state: Flammable.State):
	var tile := _flammable.get_tile()
	var item_holder := tile.get_mixin(ItemHolder) as ItemHolder

	exit()
