class_name ExtinguisherImpl
extends Item

signal foam_strength_changed(strength: float)
signal pin_released

var foam_strength: float = 0:
	set(value):
		if !_is_pin_released:
			return

		foam_strength = clamp(foam_strength, 0, 1)
		foam_strength_changed.emit(foam_strength)

var _is_pin_released: bool = false
var _capacity: float = 1.0


func release_pin():
	if _is_pin_released:
		return

	_is_pin_released = true
	pin_released.emit()


func _process(delta):
	_capacity -= foam_strength * delta * 0.1
