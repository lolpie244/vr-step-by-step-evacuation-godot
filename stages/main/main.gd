extends Node3D

const STRENGHT_STEP = 0.1

func _input(event):
	if event.is_action_pressed("release_pin"):
		$Extinguisher.release_pin()

	if event.is_action_pressed("increase_strenght"):
		$Extinguisher.strength += STRENGHT_STEP

	if event.is_action_pressed("decrease_strenght"):
		$Extinguisher.strength -= STRENGHT_STEP
