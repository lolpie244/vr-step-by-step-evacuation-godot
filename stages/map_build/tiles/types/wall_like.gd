class_name WallLike2D
extends Tile2D


func _is_wall(x: int, y: int):
	var tile = GameCore.grid.get_tile(x, y)
	return tile != null and tile.is_wall_like


func init():
	tile2d_init()

	var up = _is_wall(impl.pos.x, impl.pos.y - 1)
	var down = _is_wall(impl.pos.x, impl.pos.y + 1)

	if up or down:
		sprite.rotate_z(deg_to_rad(90))
