extends Area3D


func extinguish(by: Extinguisher):
	get_parent().impl.extinguish(by.foam_strength * 0.002)
