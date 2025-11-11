extends WallLike2D


func init():
	tile2d_init()

	var left = _is_wall(impl.grid, impl.pos.x - 1, impl.pos.y)
	var right = _is_wall(impl.grid, impl.pos.x + 1, impl.pos.y)
	var down = _is_wall(impl.grid, impl.pos.x, impl.pos.y - 1)
	var up = _is_wall(impl.grid, impl.pos.x, impl.pos.y + 1)

	var rotations := [[up, 90], [down, 270], [left, 180], [right, 0]].filter(func(v): return v[0])

	for i in rotations.size():
		var new_sprite = sprite.duplicate()
		new_sprite.rotate_z(deg_to_rad(rotations[i][1]))
		background.add_child(new_sprite)

	if background.get_child_count() > 2:
		background.remove_child(sprite)
		sprite = background.get_child(background.get_child_count() - 1)
