class_name Extinguisher
extends Item

signal foam_strength_changed(strength: float)
signal pin_released

enum Type {
	UNKNOWN,
	POWDER,
	CO2,
	WATER,
}

var type: Type

var fire_types: Array[FlammableMaterial.FireType] = []

var foam_strength: float = 0:
	set(value):
		if !_is_pin_released:
			return

		foam_strength = clamp(value, 0, 1)
		foam_strength_changed.emit(foam_strength)

var is_pin_released: bool:
	get():
		return _is_pin_released

var _is_pin_released: bool = false
var _capacity: float = 1.0


func _init(_type: Type):
	super._init(Vector2i.ONE)
	type = _type


func get_type():
	return ".".join([&"Extinguisher", Type.keys()[type]])


func release_pin():
	if _is_pin_released:
		return

	_is_pin_released = true
	pin_released.emit()


func extinguish(flammable: Flammable):
	if flammable.state != Flammable.State.BURNING:
		return

	if flammable.material.fire_type in fire_types:
		flammable.extinguish(foam_strength * 0.002)
	else:
		flammable.extinguish(-foam_strength * 0.002)


func _process(delta):
	_capacity -= foam_strength * delta * 0.1
