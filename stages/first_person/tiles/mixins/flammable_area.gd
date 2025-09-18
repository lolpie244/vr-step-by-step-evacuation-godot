extends Area3D


func extinguish(strength: float):
	get_parent().impl.extinguish(strength)
