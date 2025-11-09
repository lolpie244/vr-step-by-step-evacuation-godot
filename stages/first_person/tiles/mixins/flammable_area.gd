extends Area3D


func extinguish(by: Extinguisher):
	by.extinguish(get_parent().impl)
