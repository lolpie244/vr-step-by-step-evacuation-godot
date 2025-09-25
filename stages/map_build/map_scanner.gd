class_name MapScanner
extends Node

signal end_scene(map: Array)

var _anchors: Array[XRAnchor] = []

@onready var scene_manager: OpenXRFbSceneManager = $"../PlayerVR/SceneManager"
@onready var spartial_anchor_manager: OpenXRFbSpatialAnchorManager = $"../PlayerVR/SpatialAnchorManager"


func start_scan():
	scene_manager.request_scene_capture()

	while not scene_manager.are_scene_anchors_created() or _anchors.size() == 0:
		await Engine.get_main_loop().create_timer(1).timeout

	call_deferred("_set_map_data")


func _on_scene_capture_completed(success: bool) -> void:
	if !success:
		printerr("Failed to capture scene")
		return

	# Recreate scene anchors since the user may have changed them.
	if scene_manager.are_scene_anchors_created():
		scene_manager.remove_scene_anchors()

	scene_manager.create_scene_anchors()


func _on_scene_anchor_created(scene_node: Object, _spatial_entity: Object) -> void:
	_anchors.append(scene_node)


func _set_map_data():
	var left_corner := Vector2(1000, 1000)
	var right_corner := Vector2(-1000, -1000)

	var to_remove := []
	for anchor in _anchors:
		if !anchor.get("valid"):
			to_remove.append(anchor)
			continue

		print(anchor.label)
		print("	size:", anchor.aabb.size)
		print("	position:", anchor.aabb.position)
		print("	rotation:", anchor.mesh_instance.global_rotation)

		left_corner = Vector2(
			min(left_corner.x, anchor.left_corner.x),
			min(left_corner.y, anchor.left_corner.y),
		)

		right_corner = Vector2(
			max(right_corner.x, anchor.right_corner.x),
			max(right_corner.y, anchor.right_corner.y),
		)

	for anchor in to_remove:
		_anchors.erase(anchor)

	var size: Vector2i = round((right_corner - left_corner) / Constants.TILE_SIZE_IN_REAL_LIFE)
	var map := Utils.get_matrix(size.x, size.y)

	for anchor in _anchors:
		var left := anchor.left_corner - left_corner
		var right := left + Vector2(
			max(Constants.TILE_SIZE_IN_REAL_LIFE, anchor.size.x),
			max(Constants.TILE_SIZE_IN_REAL_LIFE, anchor.size.y)
		)

		var start = round(left / Constants.TILE_SIZE_IN_REAL_LIFE)
		var end = round(right / Constants.TILE_SIZE_IN_REAL_LIFE)

		for x in range(start.x, min(size.x, end.x)):
			for y in range(start.y, min(size.y, end.y)):
				if map[x][y] == null || map[x][y] < anchor.type:
					map[x][y] = anchor.type

	end_scene.emit(map)


func _on_scene_data_missing() -> void:
	print("Missing data")
	pass # Replace with function body.
