extends GridItem

class_name Character

var _character_body: Node3D
var _shared_data: CharacterFactory.SharedData
var _wallkable: Wallkable
var _speed: int
var _reachable: Array[Wallkable.ReachableResult] = []

@onready var Pickable: XRToolsPickable = $PickableObject


func _init(shared_data = null, grid_ = null, x_ = 0, y_ = 0) -> void:
	if shared_data == null:
		return

	self._shared_data = shared_data
	self._speed = shared_data.default_speed

	super._init(grid_, x_, y_)


func init():
	super.init()

	_wallkable = grid.get_tile_mixin(_x, _y, Wallkable)
	assert(_wallkable != null, "Tile is not Wallkable")

	self._character_body = _generate_character_body()
	self.scale = Vector3.ONE * _get_model_scale(self._character_body)
	print(self.scale)
	self.add_child(_character_body)

	Pickable.picked_up.connect(_on_picked_up)
	Pickable.dropped.connect(_on_dropped)

	_wallkable.place_character(self)
	restore()


func get_tile() -> Tile:
	return _wallkable.get_tile()



func _generate_character_body():
	return _shared_data.character_body.duplicate(Utils.DEFAULT_DUPLICATE)


func restore():
	_speed = _shared_data.default_speed
	_reachable = _wallkable.reachable_tiles(_speed)


func place(x: int, y: int) -> bool:
	for next_tile in _reachable:
		if next_tile.tile.pos != Vector2i(x, y):
			continue

		if !next_tile.tile.get_mixin(Wallkable).place_character(self):
			_wallkable.place_character(self)
			return false

		highlight_reachable(false)
		_speed -= next_tile.distance
		_wallkable = next_tile.tile.get_mixin(Wallkable)
		_reachable = _wallkable.reachable_tiles(_speed)
		self.rotate_y(
			Vector2(next_tile.direction.y, next_tile.direction.x).angle() - self.rotation.y
		)

		return true

	return false


func highlight_reachable(highlight: bool):
	for info in _reachable:
		await get_tree().create_timer(0.1).timeout
		info.tile.highlight = highlight


func visible_tiles():
	var tiles := ShadowCasting.visible_tiles(_wallkable.get_tile())
	for tile in tiles:
		if tile != null:
			tile.highlight = true

func _process(_delta: float) -> void:
	if Pickable.is_picked_up():
		self.global_transform = Pickable.global_transform


var _original_scale : Vector3
func _on_picked_up(_holder) -> void:
	_original_scale = self.scale

func _on_dropped(_pickable) -> void:
	_wallkable.place_character(self)
	self.scale = _original_scale
