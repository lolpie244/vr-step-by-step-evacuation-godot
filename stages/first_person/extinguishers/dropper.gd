class_name ExtinguisherDropper
extends RopeTrigger

@export var extinguisher: ExtinguisherNode
@onready var type: Extinguisher.Type = extinguisher.type


func _ready() -> void:
	$End.hide()
	$Rope.attached_to_end = extinguisher.body


func _on_triggerred() -> void:
	$Rope.drop_end()
	self.remove()
