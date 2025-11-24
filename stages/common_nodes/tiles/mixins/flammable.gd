@tool
extends Node3D

@export var _draw_wind := false
@export var material: FlammableMaterial
@export var particles_scale := 1.0
@export var material_overlay: ShaderMaterial = preload("flammable_material.tres").duplicate()

var impl: Flammable
var _fire_enabled: bool = true
var _fire_transform: Transform3D

@onready var tile: TileNode = get_parent()
@onready var fire: FireEffect = Utils.find_child_with_type(self, FireEffect, false)
@onready var _full_fire_scale = fire.scale


func _ready():
	if !tile.impl:
		return
	material_overlay = material_overlay.duplicate()

	impl = tile.impl.get_or_create_mixin(Flammable)
	if fire:
		fire.particles_scale = particles_scale

	_set_matetial_overlay(tile)

	impl.state_changed.connect(_on_impl_state_changed)
	impl.strength_changed.connect(_on_impl_strength_changed)
	impl.durability_changed.connect(_on_impl_durability_changed)
	impl._tile_material = material
	_on_impl_state_changed(impl, impl.state)
	_on_impl_durability_changed(impl, impl.durability)
	if impl.strength:
		_on_impl_strength_changed(impl, impl.strength)

	var item_holder: ItemHolderNode = Utils.find_child_with_type(tile, ItemHolderNode, false)
	if item_holder:
		item_holder.item_node_part_placed.connect(_on_item_part_placed)
		item_holder.item_node_part_removed.connect(_on_item_part_removed)

		item_holder.item_node_placed.connect(_on_item_placed)
		item_holder.item_node_removed.connect(_on_item_removed)


func _set_matetial_overlay(node: Node3D):
	for mesh in Utils.find_children_with_type(node, MeshWithMaterial, true):
		(mesh as MeshWithMaterial).overlay_material = material_overlay


func _on_impl_state_changed(_impl: Flammable, state: Flammable.State) -> void:
	if impl.state == Flammable.State.BURNING:
		show()
		if fire:
			fire.enabled = _fire_enabled
	else:
		hide()
		if fire:
			fire.enabled = false


func _on_impl_strength_changed(_flammable: Flammable, strength: float) -> void:
	if fire == null:
		return

	fire.cooling_coef = 1 - strength
	fire.scale = _full_fire_scale * strength


func _on_impl_durability_changed(_flammable: Flammable, durability: float) -> void:
	material_overlay.set_shader_parameter("durability", durability)


func _on_item_part_placed(_item: ItemNode) -> void:
	_fire_enabled = false
	_on_impl_state_changed(impl, impl.state)


func _on_item_part_removed(_item: ItemNode) -> void:
	_fire_enabled = true
	_on_impl_state_changed(impl, impl.state)


func _on_item_placed(item: ItemNode) -> void:
	if !is_inside_tree():
		return
	_set_matetial_overlay(item)
	_fire_transform = fire.transform
	fire.reparent(item)
	var item_aabb: AABB = Utils.get_aabb(item)
	var item_size: Vector3 = item_aabb.size
	if item.impl().get_direction() in [Utils.Direction.LEFT, Utils.Direction.RIGHT]:
		item_size = Vector3(item_size.z, item_size.y, item_size.x)

	fire.position = item_aabb.get_center()
	_full_fire_scale *= (
		(fire.scale / _fire_transform.basis.get_scale()) * Vector3(item_size.x, 1, item_size.z)
	)
	_on_impl_strength_changed(impl, impl.strength)


func _on_item_removed(_item: ItemNode) -> void:
	fire.reparent(self, false)
	fire.transform = _fire_transform


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
