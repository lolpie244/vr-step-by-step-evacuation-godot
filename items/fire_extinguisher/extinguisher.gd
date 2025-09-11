@tool
extends XRToolsPickable

signal strength_changed(strength: float)


var is_pin_released: bool = false

var strength: float:
	set(value):
		if not is_pin_released:
			print("ERROR")
			return

		strength = clamp(value, 0, 1)
		strength_changed.emit(strength)


func release_pin():
	if is_pin_released:
		print("Pin already released")
		return

	is_pin_released = true
	$AnimationPlayer.play("release_pin")


func _ready():
	pass
