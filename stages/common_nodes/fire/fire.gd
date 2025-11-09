@tool
class_name FireEffect
extends Node3D

var fire_scale: Vector2
var particles_scale: float = 1

var cooling_coef = 0.2:
	set(val):
		cooling_coef = val
		fire.material_override.set_shader_parameter("temperature_cooling_rate", val)

var enabled := false:
	set(val):
		enabled = val
		fire.emitting = val
		sparks.emitting = val

@onready var fire: GPUParticles3D = $Fire
@onready var sparks: GPUParticles3D = $Fire/Sparks
@onready var root = get_parent()


func _process(_delta: float) -> void:
	var new_scale = global_basis.get_scale()
	new_scale = Vector2(new_scale.x, new_scale.z)

	if !enabled || fire_scale == new_scale:
		return

	fire_scale = new_scale

	var time_scale: float = root.global_basis.get_scale().y

	(fire.draw_pass_1 as BoxMesh).size = Vector3.ONE * fire_scale.x * particles_scale
	(sparks.draw_pass_1 as QuadMesh).size = fire_scale * particles_scale

	fire.speed_scale = time_scale
	sparks.speed_scale = time_scale
	fire.lifetime = time_scale
	sparks.lifetime = time_scale


func _ready():
	fire.draw_pass_1 = fire.draw_pass_1.duplicate(true)
	fire.process_material = fire.process_material.duplicate(true)
	fire.material_override = fire.material_override.duplicate(true)
	sparks.draw_pass_1 = sparks.draw_pass_1.duplicate(true)
	sparks.process_material = sparks.process_material.duplicate(true)
