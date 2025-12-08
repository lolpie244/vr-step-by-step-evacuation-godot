extends Dial

@onready var fire_origin: Node3D = $FireOrigin
@onready var fire: FireEffect = $FireOrigin/Fire


func _ready() -> void:
	fire.enabled = true
	value = Constants.fire_spreading_rate


func _on_value_changed(_value: float) -> void:
	fire.cooling_coef = 1 - value
	fire_origin.scale.x = value - 0.122
