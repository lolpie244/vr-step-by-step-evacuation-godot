extends Node3D

@export var particles_scale: float = 1.0

var impl: Smokable

var enabled: bool = false:
	set(val):
		enabled = val
		visible = enabled
		particles.emitting = enabled

var _old_scale: Vector3

@onready var tile: TileNode = get_parent()
@onready var particles: GPUParticles3D = $Particles
@onready var original_gravity: Vector3 = particles.process_material.gravity


func _ready():
	if !tile.impl:
		return
	hide()
	particles.emitting = false
	particles.draw_pass_1 = particles.draw_pass_1.duplicate(true)
	particles.process_material = particles.process_material.duplicate(true)

	impl = tile.impl.get_or_create_mixin(Smokable)
	impl.state_changed.connect(_on_impl_state_changed)
	impl.strength_changed.connect(_on_impl_strength_changed)
	_on_impl_state_changed(impl.state)
	_on_impl_strength_changed(impl.strength)


func _on_impl_state_changed(state: Smokable.State):
	enabled = state == Smokable.State.SMOKE


func _on_impl_strength_changed(strength: float):
	particles.amount_ratio = strength
	var material: StandardMaterial3D = particles.draw_pass_1.surface_get_material(0)
	var color := material.albedo_color
	color.a = strength
	material.albedo_color = color


func _process(_delta: float) -> void:
	var new_scale := global_basis.get_scale()
	if !enabled || _old_scale == new_scale:
		return
	_old_scale = new_scale
	var smoke_scale: float = min(new_scale.x, new_scale.z)
	var time_scale: float = new_scale.y
	particles.draw_pass_1.size = Vector2.ONE * smoke_scale * particles_scale
	particles.process_material.gravity = time_scale * original_gravity
