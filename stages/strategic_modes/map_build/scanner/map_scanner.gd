class_name MapScanner
extends Node

signal map_scanned(map: MapGrid)
var _anchors: Array[XRAnchor] = []
var _scanner_timer := Metrics.ExecutionTimer.new("MapScan")

@onready var scene_manager: OpenXRFbSceneManager = $"../PlayerVR/SceneManager"


func start_scan() -> void:
	scene_manager.request_scene_capture()
	_scanner_timer.start()
	while not scene_manager.are_scene_anchors_created() or _anchors.size() == 0:
		await Engine.get_main_loop().create_timer(0.1).timeout

	call_deferred("_set_map_data")


func _on_scene_capture_completed(success: bool) -> void:
	if !success:
		printerr("Failed to capture scene")
		return

	scene_manager.create_scene_anchors()


func _on_scene_anchor_created(scene_node: Object, _spatial_entity: Object) -> void:
	_anchors.append(scene_node)


func _set_tile(map: MapGrid, anchor: TileXRAnchor):
	var skip := false
	var start: Vector2i = floor(anchor.left_corner / Constants.TILE_SIZE_IN_REAL_LIFE)
	var end: Vector2i = ceil(anchor.right_corner / Constants.TILE_SIZE_IN_REAL_LIFE)
	end = Vector2i(
		min(map.size.x, max(end.x, start.x + 1)),
		min(map.size.y, max(end.y, start.y + 1)),
	)
	for x in range(start.x, end.x):
		if skip:
			break
		for y in range(start.y, end.y):
			if map.get_tile(x, y) == null:
				map.create_tile(anchor.get_type(), x, y)
				if anchor.is_item_holder():
					map.get_tile(x, y).get_or_create_mixin(ItemHolder)
				if not anchor.is_multiple_tiles():
					skip = true
					break


func _set_furniture(map: MapGrid, anchor: FurnitureXRAnchor):
	var center := (
		(anchor.left_corner + anchor.right_corner) / 2.0 / Constants.TILE_SIZE_IN_REAL_LIFE
	)
	var start := center - anchor.item.size / 2.0

	var base_tile: Tile = map.get_tile(round(start.x), round(start.y))
	if !base_tile:
		base_tile = Tile.new(Tile.Type.NONE, map, round(start.x), round(start.y))

	var result_tile: Tile = null
	var distance: float = INF
	for tile in base_tile.neighbor_tiles() + [base_tile]:
		if anchor.item.is_valid_placement(tile, anchor.item._direction):
			var tile_distance := start.distance_squared_to(tile.pos)
			if tile_distance < distance:
				distance = tile_distance
				result_tile = tile

	if !result_tile:
		return

	map.add_item(anchor.item)
	anchor.item.place(result_tile, anchor.item.get_direction())


func _set_map_data():
	var left_corner := Vector2(INF, INF)
	var right_corner := Vector2(-INF, -INF)

	for i in range(_anchors.size() - 1, -1, -1):
		var anchor := _anchors[i]
		if not anchor.has_method("is_valid") or not anchor.is_valid():
			_anchors.remove_at(i)
			continue

		if not anchor.is_initialized:
			await anchor.initialized

		left_corner = Vector2(
			min(left_corner.x, anchor.left_corner.x),
			min(left_corner.y, anchor.left_corner.y),
		)

		right_corner = Vector2(
			max(right_corner.x, anchor.right_corner.x),
			max(right_corner.y, anchor.right_corner.y),
		)

	_anchors.sort_custom(
		func(a: XRAnchor, b: XRAnchor):
			if a is TileXRAnchor and b is FurnitureXRAnchor:
				return true
			if a is FurnitureXRAnchor and b is TileXRAnchor:
				return false
			return a.get_type() > b.get_type()
	)
	var size: Vector2i = ceil((right_corner - left_corner) / Constants.TILE_SIZE_IN_REAL_LIFE)
	var map := MapGrid.new(size)

	for anchor in _anchors:
		anchor.left_corner -= left_corner
		anchor.right_corner -= left_corner

		if anchor is TileXRAnchor:
			_set_tile(map, anchor)
		if anchor is FurnitureXRAnchor:
			_set_furniture(map, anchor)

	scene_manager.remove_scene_anchors()
	_scanner_timer.stop()
	map_scanned.emit(map)


func _on_scene_data_missing() -> void:
	print("Missing data")
