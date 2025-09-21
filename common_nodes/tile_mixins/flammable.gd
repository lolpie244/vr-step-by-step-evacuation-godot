@tool
extends Node3D

@export var _draw_wind := false
@export var material: TileMaterial
@export var particles_scale := 1.0

@onready var tile: TileNode = get_parent()
@onready var impl: Flammable = tile.impl.get_or_create_mixin(Flammable)
@onready var fire: FireEffect = Utils.find_child_with_type(self, FireEffect, false)


func _ready():
	if fire:
		fire.particles_scale = particles_scale

	impl.state_changed.connect(_on_impl_state_changed)
	impl.strenght_changed.connect(_on_impl_strength_changed)
	impl.material = material
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


func _process(_delta):
	_debug_draw_wind()


func _debug_draw_wind():
	if !impl || !_draw_wind:
		return

	var new_pos = global_position
	var direction := Vector3(impl.wind.x, 0, impl.wind.y)
	new_pos.x += impl.wind.x * global_basis.get_scale().x
	new_pos.z += impl.wind.y * global_basis.get_scale().z
	var color = Color.BLUE

	color.b -= impl.wind.length() * 0.1

	DebugDraw3D.draw_arrow_ray(global_position, -direction, 0.01, color, 0.001)
