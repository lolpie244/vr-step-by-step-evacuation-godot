extends RopeTrigger


func _on_triggerred() -> void:
	$Rope.drop_end()
