extends GridItem

class_name Character

var _character_body: CharacterBody3D
var _shared_data: CharacterFactory.SharedData

var _original_transform: Transform3D


func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data

	super._init(grid_, x_, y_)


func init():
	var tile: Tile = grid.get_tile(x, y)

	assert(tile != null, "Tile doesn't exists")
	assert(tile.has_flag(Tile.Flags.WALKABLE), "Tile is not Walkable")

	self._character_body = _generate_character_body()
	self.add_child(_character_body)

	tile.add_character(self)
	super.init()

	self._original_transform = self.transform


func original_transform() -> Transform3D:
	return _original_transform


func _generate_character_body():
	var model = _shared_data.character_body.duplicate()
	return _resize_model(model)
