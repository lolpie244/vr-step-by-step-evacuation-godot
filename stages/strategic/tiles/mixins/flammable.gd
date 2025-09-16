extends Node3D

@onready var Impl: Flammable = $Impl.instance

func _ready():
	_on_impl_state_changed(Impl.state)

func _on_impl_state_changed(state: Flammable.State) -> void:
	if Impl.state == Flammable.State.BURNING:
		show()
		$Fire.enabled = true
	else:
		hide()
		$Fire.enabled = false
