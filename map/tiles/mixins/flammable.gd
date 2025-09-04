extends TileMixin

class_name Flammable

@export var material: TileMaterial

var burning: bool = false
var burned: bool = false


func _ready():
	hide()


func init() -> void:
	scale(_tile.scale.x)


func scale(scale_: float):
	var process_material: ParticleProcessMaterial = $Particles.process_material
	process_material.scale_max = scale_
	process_material.scale_min = scale_
	process_material.emission_shape_scale = Vector3.ONE * scale_
	process_material.gravity *= scale_


func can_burn():
	return !burning && !burned


func ignite():
	burning = true
	show()
