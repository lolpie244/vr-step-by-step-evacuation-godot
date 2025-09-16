extends Node3D

@onready var Impl: Walkable = $Impl

var _bodies_in_snap_zone_area: Array[XRToolsPickable] = []

func _ready() -> void:
	hide()

func _character_placed(craracter_rigid: RigidBody3D):
	#var character : Character = craracter_rigid.get_parent()
	#character.place(self)
	Impl.get_tile().highlight = false

func _on_snap_zone_body_entered(body_: Node3D) -> void:
	if not is_instance_of(body_, XRToolsPickable) || !self.enabled:
		return

	var body: XRToolsPickable = body_
	#var character: Character = body.get_parent()

	#if !body.is_picked_up() || body in _bodies_in_snap_zone_area || character.is_reachable(self) == null:
		#return

	Impl.get_tile().highlight = true
	_bodies_in_snap_zone_area.append(body)
	body.dropped.connect(_character_placed)


func _on_snap_zone_body_exited(body: Node3D) -> void:
	if is_instance_of(body, XRToolsPickable) and body in _bodies_in_snap_zone_area:
		_bodies_in_snap_zone_area.erase(body)
		body.dropped.disconnect(_character_placed)
		Impl.get_tile().highlight = false
