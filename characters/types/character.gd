extends GridItem

class_name Character

var _character_body: Node3D
var _shared_data: CharacterFactory.SharedData
var _walkable: Walkable
var _speed: int
var _reachable: Array[Walkable.ReachableResult] = []

var _tile_changed := false
var _reachable_highlighted := false

@onready var Pickable: XRToolsPickable = $PickableObject


func _init(shared_data = null, grid_ = null, x_ = 0, y_ = 0) -> void:
	if shared_data == null:
		return

	self._shared_data = shared_data
	self._speed = shared_data.default_speed

	super._init(grid_, x_, y_)


func init():
	super.init()

	_walkable = grid.get_tile_mixin(_x, _y, Walkable)
	assert(_walkable != null, "Tile is not Walkable")

	self._character_body = _generate_character_body()
	self.scale = Vector3.ONE * _get_model_scale(self._character_body)
	self.add_child(_character_body)

	Pickable.picked_up.connect(_on_picked_up)
	Pickable.dropped.connect(_on_dropped)

	_walkable.place_character(self)
	restore()


func get_tile() -> Tile:
	return _walkable.get_tile()



func _generate_character_body():
	return _shared_data.character_body.duplicate(Utils.DEFAULT_DUPLICATE)


func restore():
	_speed = _shared_data.default_speed
	_reachable = _walkable.reachable_tiles(_speed)
	_original_scale = self.scale


func place(walkable: Walkable) -> bool:
	var next_tile = is_reachable(walkable)
	if next_tile == null || !walkable.place_character(self):
		_walkable.place_character(self)
		return false

	highlight_reachable(false)
	_speed -= next_tile.distance
	_walkable = next_tile.tile.get_mixin(Walkable)
	_reachable = _walkable.reachable_tiles(_speed)
	self.rotate_y(
		Vector2(next_tile.direction.y, next_tile.direction.x).angle() - self.rotation.y
	)
	_tile_changed = true

	return true

func is_reachable(walkable: Walkable) -> Walkable.ReachableResult:
	for next_tile in _reachable:
		if next_tile.tile == walkable.get_tile():
			return next_tile
	return null


func highlight_reachable(highlight: bool):
	_reachable_highlighted = highlight
	for info in _reachable:
		await get_tree().create_timer(0.05).timeout
		info.tile.highlight = highlight


func visible_tiles():
	var tiles := ShadowCasting.visible_tiles(_walkable.get_tile())
	for tile in tiles:
		if tile != null:
			tile.highlight = true

func _process(_delta: float) -> void:
	if Pickable.is_picked_up():
		self.global_transform = Pickable.global_transform


var _original_scale : Vector3
func _on_picked_up(_holder) -> void:
	highlight_reachable(false)

func _on_dropped(_pickable) -> void:
	self.set_deferred("scale", _original_scale)

	(func():
		if !_tile_changed:
			self._walkable.place_character(self)
		_tile_changed = false
		self.scale = _original_scale
	).call_deferred()

func on_poke():
	highlight_reachable(!_reachable_highlighted)
