@tool
extends HoseEndNode


func _on_rope_max_extend(limit_position: Vector3):
	if !pickup.is_picked_up():
		return

	pickup._grab_driver.primary.by.global_transform = _last_hand_transform
	self.global_position = limit_position
