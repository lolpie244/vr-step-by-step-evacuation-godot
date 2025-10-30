extends Node3D

var impl: Walkable

var _bodies_in_snap_zone_area: Array[XRToolsPickable] = []

@onready var tile: TileNode = get_parent()
@onready var map: StrategicMap = Utils.find_parent_that_implements(tile, "Map")


func _ready() -> void:
	if !tile.impl:
		return
	impl = tile.impl.get_or_create_mixin(Walkable)

	impl.on_chacter_placed.connect(_on_character_placed)
	hide()


func _on_snap_zone_body_entered(_body: Node3D) -> void:
	if not _body is XRToolsPickable || !_body.get_parent() is CharacterStrategic:
		return

	var body: XRToolsPickable = _body
	var character_node: CharacterStrategic = body.get_parent()
	var character: Character = character_node.impl

	var max_radius := 0.1
	if body.global_position.distance_to(global_position) > max_radius:
		return

	if (
		!body.is_picked_up()
		|| body in _bodies_in_snap_zone_area
		|| character.is_reachable(impl) == null
	):
		return

	impl.get_tile().highlight = true
	_bodies_in_snap_zone_area.append(body)
	body.dropped.connect(_character_dropped)


func _on_snap_zone_body_exited(body: Node3D) -> void:
	if is_instance_of(body, XRToolsPickable) and body in _bodies_in_snap_zone_area:
		_bodies_in_snap_zone_area.erase(body)
		body.dropped.disconnect(_character_dropped)
		impl.get_tile().highlight = false


func _on_character_placed(character: Character):
	var character_node: CharacterStrategic = map.get_character_node(character)

	if character_node.get_parent() == null:
		get_parent().add_child(character_node)

	if character_node.get_parent() != get_parent():
		character_node.reparent(get_parent(), false)

	character_node.position = self.position
	character_node.rotation = self.rotation

	character_node.scale = Vector3.ONE

	var character_scale_local = tile.map.model_scale(character_node.model)
	var character_scale_global = character_node.global_basis.get_scale().x
	character_node.scale = Vector3.ONE * (character_scale_local / character_scale_global)
	impl.get_tile().highlight = false

	var parent = character_node.get_parent()
	while parent:
		parent = parent.get_parent()


func _character_dropped(craracter_rigid: RigidBody3D):
	var character: Character = craracter_rigid.get_parent().impl
	character.place(impl.get_tile())
	impl.get_tile().highlight = false
