extends Node3D

@onready var Impl: Walkable = $Impl

var _bodies_in_snap_zone_area: Array[XRToolsPickable] = []

func _ready() -> void:
	hide()

func _on_snap_zone_body_entered(body_: Node3D) -> void:
	if not is_instance_of(body_, XRToolsPickable):
		return

	var body: XRToolsPickable = body_
	var character_node: CharacterStrategic = body.get_parent()
	var character: Character = character_node.Impl

	if !body.is_picked_up() || body in _bodies_in_snap_zone_area || character.is_reachable(Impl) == null:
		return

	Impl.get_tile().highlight = true
	_bodies_in_snap_zone_area.append(body)
	body.dropped.connect(_character_dropped)


func _on_snap_zone_body_exited(body: Node3D) -> void:
	if is_instance_of(body, XRToolsPickable) and body in _bodies_in_snap_zone_area:
		_bodies_in_snap_zone_area.erase(body)
		body.dropped.disconnect(_character_dropped)
		Impl.get_tile().highlight = false


func _on_character_placed(character: Character):
	var character_node = character.get_parent()

	if character_node.get_parent() == null:
		get_parent().add_child(character_node)

	if character_node.get_parent() != get_parent():
		character_node.reparent(get_parent(), false)

	character_node.position = self.position
	character_node.rotation = self.rotation

	character_node.scale = Vector3.ONE
	var character_scale_local = Impl._tile.grid.model_scale(character_node.model)
	var character_scale_global = character_node.global_basis.get_scale().x
	character_node.scale = Vector3.ONE * (character_scale_local / character_scale_global)
	Impl.get_tile().highlight = false

	var parent = character_node.get_parent()
	while parent:
		parent = parent.get_parent()

func _character_dropped(craracter_rigid: RigidBody3D):
	var character : Character = craracter_rigid.get_parent().Impl
	character.place(Impl.get_tile())
	Impl.get_tile().highlight = false
