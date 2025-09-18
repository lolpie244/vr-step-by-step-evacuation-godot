extends TileNode
class_name WallLikeTile

func _is_wall(x_: int, y_: int):
	var tile = map.get_tile_node(Vector2i(x_, y_))
	return tile != null and tile is WallLikeTile


func _init() -> void:
	pass
	#blocking = true

func _get_model():
	var left = _is_wall(Impl.pos.x - 1, Impl.pos.y)
	var right = _is_wall(Impl.pos.x + 1, Impl.pos.y)

	if left or right:
		model.rotate_y(deg_to_rad(90))

	return model
