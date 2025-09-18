@tool
extends Node3D

@onready var tile: TileNode = Utils.find_parent_that_implements(self, "TileNode")
@onready var impl: Flammable = tile.impl.get_or_create_mixin(Flammable)


func _ready():
	impl.state_changed.connect(_on_impl_state_changed)
	_on_impl_state_changed(impl.state)


func _on_impl_state_changed(state: Flammable.State) -> void:
	if impl.state == Flammable.State.BURNING:
		show()
		$Fire.enabled = true
	else:
		hide()
		$Fire.enabled = false
