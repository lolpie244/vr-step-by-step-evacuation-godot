@tool
extends Node3D

signal triggered

const MAX_PULL := 0.06
const MAX_ROTATION := 45

@export var reverse: bool = false

var _syncer: Sync

@onready var model_origin: Node3D = $ModelOrigin
@onready var model: Node3D = $ModelOrigin/Model
@onready var pickup: XRToolsPickable = $Pickup
@onready var rumble_area: Area3D = $RumbleArea


func _ready() -> void:
	if reverse:
		model.rotate_z(deg_to_rad(180))

	var parent_tile: TileNode = Utils.find_parent_that_implements(self, "TileNode")
	if !parent_tile.impl:
		return

	for tile in parent_tile.impl.direct_neighbor_tiles():
		var flammable: Flammable = tile.get_mixin(Flammable)
		if flammable and flammable.state == Flammable.State.BURNING:
			rumble_area.monitorable = true


func _process(_delta: float) -> void:
	if !pickup.is_picked_up():
		return

	var pickup_pos := global_transform.affine_inverse() * pickup.global_position
	var pull = max(0.0, -pickup_pos.y)

	if pull < MAX_PULL:
		model_origin.rotation_degrees.x = (pull / MAX_PULL) * MAX_ROTATION
	else:
		triggered.emit()

	if _syncer:
		_syncer.sync()


func _on_pickup_picked_up(_pickable: Variant) -> void:
	_syncer = Sync.new(pickup._grab_driver.primary.hand, model_origin)


func _on_pickup_dropped(_pickable: Variant) -> void:
	model_origin.rotation_degrees.x = 0
	pickup.transform = Transform3D()
	_syncer = null
