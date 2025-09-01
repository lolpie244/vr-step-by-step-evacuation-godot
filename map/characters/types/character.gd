extends GridItem

class_name Character

var _character_body: CharacterBody3D
var _shared_data: CharacterFactory.SharedData
var _tile: Tile
var _speed: float


func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data
	self._speed = shared_data.default_speed

	super._init(grid_, x_, y_)


func init():
	_tile = grid.get_tile(_x, _y)

	assert(_tile != null, "Tile doesn't exists")
	assert(_tile.has_flag(Tile.Flags.WALKABLE))

	self._character_body = _generate_character_body()
	self.add_child(_character_body)

	super.init()
	_tile.place_character(self)


func _generate_character_body():
	var model = _shared_data.character_body.duplicate()
	return _resize_model(model)


func reachable_tiles():
	var result := []

	var queue := [[_tile, _speed]]
	var used := {}

	while queue.size():
		var info = queue.pop_front()
		var current_tile: Tile = info[0]
		var speed: int = info[1]

		if speed == 0:
			continue

		for tile in current_tile.neighbor_tiles():
			if !tile.has_flag(Tile.Flags.WALKABLE) || used.has(tile.get_instance_id()):
				continue
			result.append(tile)

			used[tile.get_instance_id()] = true
			queue.append([tile, speed - 1])

	return result


func highlight_tiles(highlight: bool):
	for tile in reachable_tiles():
		await get_tree().create_timer(0.1).timeout
		tile.highlight(highlight)
