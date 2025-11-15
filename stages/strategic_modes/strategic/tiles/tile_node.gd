class_name StrategicTileNode
extends TileNode

@onready var animation: AnimationPlayer = get_node_or_null("Animation")


func init():
	super.init()
	impl.highlight_changed.connect(_on_impl_highlight_changed)

	var visible: Visible = impl.get_mixin(Visible)
	if visible:
		visible.visible_changed.connect(_on_visible_changed)
		_on_visible_changed(visible.is_visible())


func _on_impl_highlight_changed(value: bool) -> void:
	if !animation:
		return

	if animation.is_playing():
		await animation.animation_finished
	if value:
		animation.play("highlight")
	else:
		animation.play_backwards("highlight")


func _on_visible_changed(_is_visible: bool) -> void:
	if _is_visible:
		show()
	else:
		hide()
