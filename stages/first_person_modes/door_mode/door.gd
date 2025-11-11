extends FirstPersonDoor

@onready var animation: AnimationPlayer = $Animation


func _on_handle_triggered() -> void:
	impl.get_mixin(Blockable).blocking = false
	animation.play(&"open")
