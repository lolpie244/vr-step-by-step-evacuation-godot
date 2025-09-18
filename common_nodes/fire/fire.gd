@tool
extends Node3D
class_name FireEffect

@onready var fire: GPUParticles3D = $Fire
@onready var sparks: GPUParticles3D = $Fire/Sparks
@onready var root = get_parent()

var enabled := false
var fire_scale: Vector2

var cooling_coef:
	set(val):
		cooling_coef = val
		fire.material_override.set_shader_parameter("temperature_cooling_rate", val)

func _process(_delta: float) -> void:
	var new_scale = global_basis.get_scale()
	new_scale = Vector2(new_scale.x, new_scale.z)

	if !enabled || fire_scale == new_scale:
		return

	fire_scale = new_scale
	# fire_scale = min(fire_scale.x, fire_scale.y, fire_scale.z)
	var time_scale: float = root.global_basis.get_scale().y

	(fire.draw_pass_1 as BoxMesh).size = Vector3.ONE * fire_scale.y
	(sparks.draw_pass_1 as QuadMesh).size = Vector2.ONE * fire_scale

	fire.speed_scale = time_scale
	sparks.speed_scale = time_scale
	fire.lifetime = time_scale
	sparks.lifetime = time_scale


func _ready():
	cooling_coef = 0.0
	_process(0)
