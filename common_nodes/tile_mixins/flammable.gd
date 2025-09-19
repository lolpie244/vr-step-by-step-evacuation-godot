@tool
extends Node3D

@onready var tile: TileNode = get_parent()
@onready var impl: Flammable = tile.impl.get_or_create_mixin(Flammable)
@onready var fire: FireEffect = Utils.find_child_with_type(self, FireEffect, false)


func _ready():
	impl.state_changed.connect(_on_impl_state_changed)
	impl.strenght_changed.connect(_on_impl_strength_changed)
	_on_impl_state_changed(impl.state)
	_on_impl_strength_changed(impl.strenght)


func _on_impl_state_changed(state: Flammable.State) -> void:
	if impl.state == Flammable.State.BURNING:
		show()
		if fire:
			fire.enabled = true
	else:
		hide()
		if fire:
			fire.enabled = false


func _on_impl_strength_changed(strenght: float) -> void:
	if fire == null:
		return

	fire.cooling_coef = 1 - strenght
	fire.scale = Vector3.ONE * strenght
