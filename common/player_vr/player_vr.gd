extends XROrigin3D


@onready var LeftHand = $LeftHand
@onready var RightHand = $RightHand

var	xr_interface: OpenXRInterface = XRServer.find_interface("OpenXR")


func _ready() -> void:
	xr_interface.set_action_set_active("strategic", true)

func _process(_delta):
	print("Stick valu123e ", LeftHand.get_vector2("move"))
