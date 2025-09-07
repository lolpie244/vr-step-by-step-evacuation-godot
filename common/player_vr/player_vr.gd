extends XROrigin3D


@onready var LeftHand = $LeftHand
@onready var RightHand = $RightHand

var	xr_interface: OpenXRInterface = XRServer.find_interface("OpenXR")


func _ready() -> void:
	xr_interface.set_action_set_active("strategic", true)


func _on_poke_pointing_event(event: Variant) -> void:
	if event.target.has_method("on_poke"):
		event.target.call("on_poke", event)
