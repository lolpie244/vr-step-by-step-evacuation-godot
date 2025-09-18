@tool
extends Node3D
class_name FireEffect

@onready var fire: GPUParticles3D = $Fire
@onready var sparks: GPUParticles3D = $Fire/Sparks
@onready var root = get_parent()

var enabled := false
var fire_scale: Vector3

var cooling_coef:
	set(val):
		cooling_coef = val
		fire.material_override.set_shader_parameter("temperature_cooling_rate", val)

func _process(_delta: float) -> void:
	if !enabled || fire_scale == global_basis.get_scale():
		return

	fire_scale = global_basis.get_scale()
	var time_scale: float = root.get_parent().global_basis.get_scale().x

	(fire.draw_pass_1 as BoxMesh).size = fire_scale
	(sparks.draw_pass_1 as QuadMesh).size = Vector2(fire_scale.x, fire_scale.y)
	fire.speed_scale = time_scale * 2
	sparks.speed_scale = time_scale * 2

	fire.lifetime = time_scale * 1.2
	sparks.lifetime = time_scale * 1.2


func _ready():
	cooling_coef = 0
	_process(0)
