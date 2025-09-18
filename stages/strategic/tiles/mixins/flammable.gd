extends Node3D

@onready var tile: TileNode = Utils.find_parent_that_implements(self, "TileNode")
@onready var Impl: Flammable = tile.Impl.get_or_create_mixin(Flammable)

func _ready():
	Impl.state_changed.connect(_on_impl_state_changed)
	_on_impl_state_changed(Impl.state)

func _on_impl_state_changed(state: Flammable.State) -> void:
	if Impl.state == Flammable.State.BURNING:
		show()
		$Fire.enabled = true
	else:
		hide()
		$Fire.enabled = false
