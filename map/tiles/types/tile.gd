extends GridItem

class_name Tile

enum Flags {
	WALKABLE = 1 << 0,
	BLOCKING = 1 << 1,
	BURNING = 1 << 2,
	BURNED = 1 << 3,
}

var _model: Node3D
var _shared_data: TileFactory.SharedData
var _animation: AnimationPlayer
var _fire: FirePoint

var material: TileMaterial
var wind: Vector2


func _init(shared_data, grid_, x_, y_) -> void:
	self._shared_data = shared_data
	self._flags = _shared_data.flags
	self._animation = _shared_data.animation.duplicate()
	self.material = _shared_data.material

	self.add_child(_animation)

	super._init(grid_, x_, y_)


func init():
	self._model = _generate_model()
	self.add_child(_model)
	if _shared_data.fire_point:
		_fire = _shared_data.fire_point.duplicate()
		_fire.visible = false
		_fire.scale(_model.scale.x)
		self.add_child(_fire)

	self.position = grid.tile_position(_x, _y)

	super.init()


func _generate_model():
	return _resize_model(_shared_data.model.duplicate())


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
	else:
		_animation.play_backwards("highlight")


func ignite():
	add_flag(Flags.BURNING)
	if _fire != null:
		# print("FIRE")
		_fire.visible = true

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
