extends Node3D

class_name FirePoint

func scale(scale_: float):
	var process_material: ParticleProcessMaterial = $Particles.process_material
	process_material.scale_max = scale_
	process_material.emission_shape_scale = Vector3.ONE * scale_
	process_material.gravity *= scale_
