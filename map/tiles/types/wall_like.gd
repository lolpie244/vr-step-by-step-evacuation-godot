extends Tile

class_name WallLikeTile


func _ready() -> void:
	add_flag(Flags.WALL)


func _is_wall(x_: int, y_: int):
	var tile = grid.get_tile(x_, y_)

	return tile != null and tile.has_flag(Flags.WALL)


func _generate_model() -> VisualInstance3D:
	var left = _is_wall(_x - 1, _y)
	var right = _is_wall(_x + 1, _y)

	var result = super._generate_model()
	if left or right:
		result.rotate_y(deg_to_rad(90))
	return result
