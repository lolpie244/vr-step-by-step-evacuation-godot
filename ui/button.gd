extends Node3D

signal pressed(button)
signal released(button)

@onready var properties: XRToolsInteractableAreaButton = $next_button/InteractableAreaButton


func _on_button_pressed(_button: Variant) -> void:
	emit_signal("pressed", self)


func _on_released(_button: Variant) -> void:
	emit_signal("released", self)
