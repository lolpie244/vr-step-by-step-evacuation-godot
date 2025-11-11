class_name FirstPersonModeExtinguisher
extends FirstPersonScene

signal extinguisher_selected

@onready var extinguisher_factory: FirstPersonExtinguisherFactory = $ExtinguisherFactory


static func is_applicable(_context: Context) -> bool:
	for tile in _context.character.get_tile().neighbor_tiles():
		var flammable: Flammable = tile.get_mixin(Flammable)
		if flammable and flammable.state == Flammable.State.BURNING:
			return true
	return false


static func scene() -> PackedScene:
	return preload("extinguisher_mode.tscn")


func _ready() -> void:
	super._ready()

	var ext_impls: Array[Extinguisher] = []

	for item in context.character.inventory:
		if item is Extinguisher:
			ext_impls.append(item)

	point_generator.points_count = ext_impls.size()

	for ext_impl in ext_impls:
		var ext := extinguisher_factory.create(ext_impl, point_generator.get_point())
		add_child(ext)
		ext.look_at(player.global_position)
		ext.triggerred.connect(func(): extinguisher_selected.emit())
		extinguisher_selected.connect(ext.remove)
		ext.spawn()
