class_name FireAlarmModeFireAlarm
extends Node3D

const MAX_PULL := 0.13
const MAX_ROTATION := 90
const PRESSED_BUTTON_POS := 0.014

var _syncer: Sync

@onready var impl: FireAlarm = get_parent().impl()

@onready var button: MeshInstance3D = $Model/Base/Button
@onready var cover: MeshInstance3D = $Model/Base/Cover
@onready var pickup: XRToolsPickable = $Pickup

@onready var button_body: StaticBody3D = $ButtonBody


func _ready() -> void:
	if !impl:
		return

	if impl.is_triggered():
		_on_impl_triggered()
	else:
		impl.triggered.connect(_on_impl_triggered)


func _process(_delta: float) -> void:
	if !pickup.is_picked_up():
		return

	var pickup_pos := global_transform.affine_inverse() * pickup.global_position
	var pull = max(0.0, pickup_pos.y)

	if pull < MAX_PULL:
		cover.rotation_degrees.x = -(pull / MAX_PULL) * MAX_ROTATION

	if _syncer:
		_syncer.sync()


func _on_pickup_picked_up(_pickable: Variant) -> void:
	_syncer = Sync.new(pickup._grab_driver.primary.hand, cover)


func _on_pickup_dropped(_pickable: Variant) -> void:
	_syncer = null


func _on_impl_triggered():
	button.position.z = PRESSED_BUTTON_POS
	button_body.collision_layer = 0


func _on_button_triggered() -> void:
	if abs(cover.rotation_degrees.x) < 45:
		return
	impl.trigger()
