class_name FlammableMaterial
extends Resource

enum FireType {
	A,  # Solids
	B,  # Liquids
	C,  # Gasses
	D,  # Metals
	E,  # Energy
	F,  # Oils
}

const CONTACT_HEAT_FRACTION := 0.01

@export var density: float  # kg/m3
@export var heat_release_rate: float  # W/g
@export var carbon_monoxide_yield: float
@export var heat_capacity: float  # J/kg
@export var thermal_conductivity: float  # J/kg
@export var ignition_temp: float

@export var flammable: bool = true
@export var fire_type: FireType

var hrr: float:
	get():
		return CONTACT_HEAT_FRACTION * heat_release_rate * 1000

var flammable_rate: float:
	get():
		return sqrt(density * thermal_conductivity * heat_capacity)
