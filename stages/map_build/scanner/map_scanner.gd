class_name MapScanner
extends Node

signal map_scanned(map: MapGrid)
var _anchors: Array[XRAnchor] = []

@onready var scene_manager: OpenXRFbSceneManager = $"../PlayerVR/SceneManager"


func start_scan() -> void:
	scene_manager.request_scene_capture()

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


func _set_tile(map: MapGrid, anchor: TileXRAnchor, start: Vector2, end: Vector2):
	var skip := false
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


func _set_furniture(map: MapGrid, anchor: FurnitureXRAnchor, start: Vector2, end: Vector2):
	for x in range(start.x, end.x):
		for y in range(end.y - 1, start.y - 1, -1):
			if anchor.item.is_valid_placement(map.get_tile(x, y), anchor.item.get_direction()):
				map.add_item(anchor.item)
				anchor.item.place(map.get_tile(x, y), anchor.item.get_direction())
				return


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
		var left := anchor.left_corner - left_corner
		var right := left + anchor.size

		var start: Vector2i = floor(left / Constants.TILE_SIZE_IN_REAL_LIFE)
		var end: Vector2i = ceil(right / Constants.TILE_SIZE_IN_REAL_LIFE)
		end = Vector2i(
			min(size.x, max(end.x, start.x + 1)),
			min(size.y, max(end.y, start.y + 1)),
		)

		if anchor is TileXRAnchor:
			_set_tile(map, anchor, start, end)
		if anchor is FurnitureXRAnchor:
			_set_furniture(map, anchor, start, end)

	scene_manager.remove_scene_anchors()
	map_scanned.emit(map)


func _on_scene_data_missing() -> void:
	print("Missing data")
