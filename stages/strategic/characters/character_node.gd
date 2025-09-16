extends Node3D
class_name CharacterStrategic

@onready var Pickable: XRToolsPickable = $PickableObject
@onready var Impl: Character = $Impl

@onready var model = $Model

var _tile_changed := false

func _ready() -> void:
	hide()
	Pickable.picked_up.connect(_on_picked_up)
	Pickable.dropped.connect(_on_dropped)


func _process(_delta: float) -> void:
	if Pickable.is_picked_up():
		self.global_transform = Pickable.global_transform


func _on_picked_up(_holder) -> void:
	_tile_changed = false
	Impl.highlight_reachable(false)


func _on_dropped(_pickable) -> void:
	(func():
		if !_tile_changed:
			Impl.restore()
		_tile_changed = false
	).call_deferred()

func on_poke():
	Impl.highlight_reachable(!Impl._reachable_highlighted)


func _on_impl_tile_changed(_tile: Tile, direction: Vector2) -> void:
	_tile_changed = true
	self.rotate_y(
		Vector2(direction.y, direction.x).angle() - self.rotation.y
	)
	show()
