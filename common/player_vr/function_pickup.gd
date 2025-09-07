@tool
extends XRToolsFunctionPickup


func _on_grab_entered(target: Node3D) -> void:
	# reject objects which don't support picking up
	for child in target.get_children():
		if is_instance_of(child, XRToolsPickable):
			target = child
			break
	super._on_grab_entered(target)
