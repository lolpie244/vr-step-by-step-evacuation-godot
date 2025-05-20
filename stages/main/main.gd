extends Node3D

const STEP = 0.1

func _input(event):
	if event.is_action_pressed("release_pin"):
		$Extinguisher.release_pin()

	if event.is_action_pressed("increase_strenght"):
		$Extinguisher.strength += STEP

	if event.is_action_pressed("decrease_strenght"):
		$Extinguisher.strength -= STEP

func _process(_delta: float) -> void:
	if Input.is_action_pressed("zoom_in"):
		$Map.zoom += STEP

	if Input.is_action_pressed("zoom_out"):
		$Map.zoom -= STEP

	if Input.is_action_pressed("up"):
		$Map.offset.x -= STEP

	if Input.is_action_pressed("down"):
		$Map.offset.x += STEP

	if Input.is_action_pressed("left"):
		$Map.offset.y += STEP

	if Input.is_action_pressed("right"):
		$Map.offset.y -= STEP
