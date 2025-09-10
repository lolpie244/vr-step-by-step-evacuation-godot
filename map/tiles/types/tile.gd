extends GridItem

class_name Tile

var _model: Node3D
var _shared_data: TileFactory.SharedData
var _animation: AnimationPlayer

var wind: Vector2


func _init(shared_data = null, grid_ = null, x_ = 0, y_ = 0) -> void:
	if shared_data == null:
		return

	self._shared_data = shared_data
	self._flags = _shared_data.flags
	self._animation = _shared_data.animation.duplicate()

	self.add_child(_animation)

	super._init(grid_, x_, y_)


func init():
	self._model = _generate_model()
	self.scale = Vector3.ONE * _get_model_scale(_model)
	self.add_child(_model)
	self.position = grid.tile_position(_x, _y)

	super.init()

func tile_scale(scale_: int):
	self.position = self.position / self.scale * scale_
	self.scale = Vector3.ONE * scale_


func _generate_model():
	var model = _shared_data.model.duplicate()
	return model

var highlight: bool:
	set(val):
		if highlight == val:
			return
		highlight = val
		if highlight:
			_animation.play("highlight")
		else:
			_animation.play_backwards("highlight")

var blocking: bool:
	get():
		return _shared_data.blocking


func neighbor_tiles() -> Array[Tile]:
	var result: Array[Tile] = []

	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 && j == 0:
				continue

			var tile: Tile = grid.get_tile(_x + i, _y + j)
			if tile != null:
				result.append(tile)
	return result
