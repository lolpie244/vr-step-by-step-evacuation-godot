@tool
extends XRToolsPickable

func _ready():
	super._ready()
	picked_up.connect(_on_picked_up)
	dropped.connect(_on_dropped)

func on_poke(event: Variant):
	if event.event_type == XRToolsPointerEvent.Type.ENTERED:
		get_parent().on_poke()

func _on_picked_up(_pickable):
	set_deferred("freeze_mode", RigidBody3D.FREEZE_MODE_KINEMATIC)

func _on_dropped(_pickable):
	set_deferred("freeze_mode", RigidBody3D.FREEZE_MODE_STATIC)
