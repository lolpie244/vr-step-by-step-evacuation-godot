extends GridItem

class_name Tile

enum Flags {
	BLOCKING = 1 << 0,
}

var _model: Node3D
var _shared_data: TileFactory.SharedData
var _animation: AnimationPlayer

var wind: Vector2


func _init(shared_data, grid_, x_, y_) -> void:
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


func _generate_model():
	var model = _shared_data.model.duplicate()
	return model


func set_cutoff(material: ShaderMaterial):
	for i in _model.get_surface_override_material_count():
		_model.set_surface_override_material(i, material)


var highlight: bool:
	set(val):
		if highlight == val:
			return
		highlight = val
		if highlight:
			_animation.play("highlight")
		else:
			_animation.play_backwards("highlight")


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
