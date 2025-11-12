class_name PlayerVR
extends XROrigin3D

var xr_interface: OpenXRInterface = XRServer.find_interface("OpenXR")

@onready var camera: XRCamera3D = $XRCamera3D
@onready var left_hand: XRController3D = $LeftHand
@onready var right_hand: XRController3D = $RightHand
@onready var _blink_length: float = $AnimationPlayer.get_animation("blink").length


func _ready() -> void:
	xr_interface.set_action_set_active("strategic", true)


func _on_poke_pointing_event(event: Variant) -> void:
	if event.target.has_method("on_poke"):
		event.target.call("on_poke", event)


func set_eyes_closed(percentage: float):
	var start_point = $XRCamera3D/MeshInstance3D.get_active_material(0).get_shader_parameter(
		"blink_percentage"
	)
	if start_point == percentage:
		return

	var start = start_point * _blink_length
	var end = percentage * _blink_length

	if start < end:
		$AnimationPlayer.play_section("blink", start, end)
	else:
		$AnimationPlayer.play_section_backwards("blink", end, start)

	await get_tree().create_timer(abs(end - start) * 1.1).timeout


func close_eyes():
	await set_eyes_closed(0.0)


func open_eyes():
	await set_eyes_closed(1.0)
