class_name MapBuilderScene
extends MapScene
const IMPLEMENTS := "MapBuilderScene"

@export var strategic: PackedScene

var _tile_nodes: Array = [[]]
var _items: Array[MapBuilderItem] = []

@onready var map_scanner: MapScanner = $MapScanner

@onready var impl: MapGrid = MapGrid.new(Vector2i(15, 15))
@onready var tile_factory: MapBuildTileFactory = $Map/TileFactory
@onready var item_catalog: ItemsCatalog = $ItemsCatalog


func _ready() -> void:
	tile_factory.set_material(map.cutoff_material)
	item_catalog.set_material(map.cutoff_material)
	_set_map(impl)
	#map_scanner.start_scan()


func _set_map(grid: MapGrid):
	impl = grid
	map.impl = impl
	_reset_map()


func _on_map_scanner_map_scanned(scanned_map: MapGrid) -> void:
	_set_map(scanned_map)


func _clear():
	for tiles in _tile_nodes:
		for tile in tiles:
			map.remove_item(tile)
			tile.free()

	_items = []
	_tile_nodes = [[]]


func _reset_map():
	_clear()

	_tile_nodes = Utils.get_matrix(impl.rows_count(), impl.columns_count())

	map._tile_size = min(
		map.get_aabb().size.x / impl.rows_count(), map.get_aabb().size.z / impl.columns_count()
	)

	for x in range(impl.rows_count()):
		for y in range(impl.columns_count()):
			if !impl.get_tile(x, y):
				impl.create_tile(Tile.Type.FLOOR, x, y)
			_tile_nodes[x][y] = tile_factory.create(impl.get_tile(x, y))
			map.place_item(_tile_nodes[x][y], x, y)

	for item in impl.items:
		item_catalog.create(item)


func _reacreate_tile(x: int, y: int):
	map.remove_item(_tile_nodes[x][y])
	_tile_nodes[x][y] = tile_factory.create(impl.get_tile(x, y))
	map.place_item(_tile_nodes[x][y], x, y)

	var item_holder = _tile_nodes[x][y].impl.get_mixin(ItemHolder)
	if item_holder and item_holder.get_item():
		item_holder.get_item().restore_position()


func _on_tile_type_changed(type: Tile.Type, pos: Vector2i) -> void:
	var item_holder: ItemHolder = impl.get_tile_mixin(pos.x, pos.y, ItemHolder)
	if item_holder and item_holder.has_item():
		item_holder.get_item().remove()

	impl.create_tile(type, pos.x, pos.y)
	_reacreate_tile(pos.x, pos.y)

	for i in range(-1, 2):
		for j in range(-1, 2):
			if abs(i) + abs(j) != 1:
				continue
			if impl._in_range(pos.x + i, pos.y + j):
				_reacreate_tile(pos.x + i, pos.y + j)


func _on_exit_button_released(_button: Variant) -> void:
	impl.strip()
	_clear()
	GameCore.set_grid(impl)
	SceneManager.replace_scene(strategic)


func add_item_node(item_node: MapBuilderItem):
	_items.append(item_node)
	item_node.impl.removed.connect(_on_item_removed)


func _on_item_removed(item: Item):
	_items.erase(get_item_node(item))


func get_item_node(item: Item) -> MapBuilderItem:
	for item_node in _items:
		if item_node.impl == item:
			return item_node
	return null


func _on_scan_room_button_released(_button: Variant) -> void:
	map_scanner.start_scan()
