extends Node3D

@onready var Impl: FlammableImpl = $Impl

func _ready():
	_on_impl_state_changed(Impl.state)

func _on_impl_state_changed(state: FlammableImpl.State) -> void:
	if Impl.state == FlammableImpl.State.BURNING:
		show()
		$Fire.enabled = true
	else:
		hide()
		$Fire.enabled = false
