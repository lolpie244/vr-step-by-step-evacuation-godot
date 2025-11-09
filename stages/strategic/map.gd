class_name StrategicMap
extends Map

var _tile_nodes: Array
var _characters: Array[CharacterStrategic]
var _items: Array[ItemNode]

@onready var tile_factory = $TileFactory
@onready var character_factory: CharacterNodeFactory = $CharacterFactory
@onready var item_factory: ItemFactory = $ItemFactory


func _ready() -> void:
	super._ready()
	impl.new_grid.connect(reset_map)

	tile_factory.set_material(cutoff_material)
	item_factory.set_material(cutoff_material)
	character_factory.set_material(cutoff_material)

	reset_map()


func reset_map():
	_tile_nodes = Utils.get_matrix(impl.rows_count(), impl.columns_count())

	_tile_size = min(
		self.get_aabb().size.x / impl.rows_count(), self.get_aabb().size.z / impl.columns_count()
	)

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			if !impl.get_tile(x, y) || impl.get_tile(x, y).type == Tile.Type.NONE:
				continue

			var tile: TileNode = tile_factory.create(impl.get_tile(x, y))
			_tile_nodes[x][y] = tile

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			if _tile_nodes[x][y]:
				place_item(_tile_nodes[x][y], x, y)

	for item in impl.items:
		var node: ItemNode = item_factory.create(item)
		_items.append(node)
		item.removed.connect(_on_item_removed)
		item.restore_position()


func add_character(type: Character.Type, pos: Vector2i):
	var character: Character = impl.create_character(type)
	var character_node: CharacterStrategic = character_factory.create(character)
	_characters.append(character_node)

	character.death.connect(_on_character_death)
	character.place(impl.get_tile(pos.x, pos.y))

	return character


func get_character_node(character: Character) -> CharacterStrategic:
	for node in _characters:
		if node.impl == character:
			return node
	return null


func get_item_node(item: Item) -> ItemNode:
	for node in _items:
		if node.impl() == item:
			return node
	return null


func _on_item_removed(item: Item):
	_items.erase(get_item_node(item))


func _on_character_death(character: Character):
	_characters.erase(get_character_node(character))
