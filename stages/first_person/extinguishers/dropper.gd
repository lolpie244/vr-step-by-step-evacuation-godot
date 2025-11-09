class_name ExtinguisherDropper
extends RopeTrigger

@export var extinguisher: ExtinguisherNode:
	set(val):
		$Rope.attached_to_end = val.get_node("Body")
		extinguisher = val

@onready var type: Extinguisher.Type = extinguisher.type


func _ready() -> void:
	$End.hide()
	extinguisher.enabled = false


func _on_triggerred() -> void:
	$Rope.drop_end()
	extinguisher.reparent(get_parent())
	self.remove()
	extinguisher.enabled = true
