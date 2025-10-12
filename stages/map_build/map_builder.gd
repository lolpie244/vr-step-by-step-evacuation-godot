extends MapScene

@export var strategic: PackedScene

var _tile_nodes: Array = [[]]

@onready var map_scanner: MapScanner = $MapScanner

@onready var impl: MapGrid = GameCore.grid
@onready var tile_factory: MapBuildTileFactory = $Factory


func _ready() -> void:
	impl.new_grid.connect(_reset_map)
	map_scanner.start_scan()


func _on_map_scanner_map_scanned(scanned_map: Array) -> void:
	GameCore.grid.set_tiles(scanned_map)


func _reset_map():
	for tiles in _tile_nodes:
		for tile in tiles:
			map.remove_item(tile)

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


func _reacreate_tile(x: int, y: int):
	map.remove_item(_tile_nodes[x][y])
	_tile_nodes[x][y] = tile_factory.create(impl.get_tile(x, y))
	map.place_item(_tile_nodes[x][y], x, y)


func _on_tile_type_changed(type: Tile.Type, pos: Vector2i) -> void:
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
	SceneManager.load_scene(strategic)
