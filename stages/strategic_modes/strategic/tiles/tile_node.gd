class_name StrategicTileNode
extends TileNode

@onready var animation: AnimationPlayer = get_node_or_null("Animation")


func init():
	super.init()
	impl.highlight_changed.connect(_on_impl_highlight_changed)


func _on_impl_highlight_changed(value: bool) -> void:
	if !animation:
		return

	if animation.is_playing():
		await animation.animation_finished
	if value:
		animation.play("highlight")
	else:
		animation.play_backwards("highlight")
