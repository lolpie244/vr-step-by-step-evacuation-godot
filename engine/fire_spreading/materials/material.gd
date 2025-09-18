extends Resource
class_name TileMaterial

@export var material: StandardMaterial3D
@export var density: float  # kg/m3
@export var heat_release_rate: float  # W/g
@export var carbon_monoxide_yield: float
@export var heat_capacity: float  # J/kg
@export var thermal_conductivity: float  # J/kg
@export var ignition_temp: float

@export var flammable: bool = true
