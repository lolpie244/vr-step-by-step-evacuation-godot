extends GridItem

class_name Tile

enum Flags {
	WALL = 1 << 0,
	WALKABLE = 1 << 1,
}

var _model: Node3D
var _shared_data: TileFactory.SharedData
var _animation: AnimationPlayer

func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data
	self._flags = _shared_data.flags
	self._animation = _shared_data.animation.duplicate()

	self.add_child(_animation)

	super._init(grid_, x_, y_)


func init():
	self._model = _generate_model()
	self.add_child(_model)

	self.position = grid.tile_position(_x, _y)

	super.init()


func place_character(character: Character) -> bool:
	if character.get_parent() != self:
		character.reparent(self)

	character.transform = Transform3D()
	character._x = self._x
	character._y = self._y

	if _shared_data.character_point != null:
		_shared_data.character_point.place_character(character)

	return true

func highlight(value: bool):
	if value:
		_animation.play("highlight")
		# self.position.y += 0.1
	else:
		_animation.play_backwards("highlight")
		# self.position.y -= 0.1


func _generate_model():
	return _resize_model(_shared_data.model.duplicate())
