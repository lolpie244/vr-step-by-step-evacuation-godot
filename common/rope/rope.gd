extends Path3D

signal max_extend(end_position: Vector3)

@export_range(3, 200, 1) var segments_count: int = 3
@export_range(3, 100, 1) var mesh_sides: int = 4
@export var thickness: float = 0.1

@export var fixed_start: bool = false
@export_range(0, 200) var fixed_start_points: int = 0
@export var fixed_end: bool = false

@export var attached_to_start: PhysicsBody3D
@export var attached_to_end: PhysicsBody3D

@onready var mesh = $CSGPolygon3D

var points : Array[Vector3]
var segments : Array[RigidBody3D]
var joints : Array[PinJoint3D]

var max_length: float

func _ready() -> void:
	var segment_length = curve.get_baked_length() / segments_count

	for i in range(segments_count + 1):
		# curve works in local_position, so we need to cast it to global
		points.append(to_global(curve.sample_baked(i * segment_length, true)))

	curve.point_count = segments_count + 1

	for i in range(segments_count):
		var body = RigidBody3D.new()
		var collision = CollisionShape3D.new()

		self.add_child(body)
		segments.append(body)
		body.add_child(collision)

		body.gravity_scale = 0.5
		body.linear_damp  = 2.0 # decrease swing
		body.angular_damp = 5.0
		body.collision_layer = 0 # so it will not move other objects

		# position rigidbody between the joints
		body.position = points[i] + (points[i + 1] - points[i]) / 2

		# create collision between joints
		collision.shape = CapsuleShape3D.new()
		collision.shape.radius = thickness
		collision.shape.height = points[i + 1].distance_to(points[i])

		body.look_at_from_position(body.position + Vector3(0.001, 0, -0.001), points[i + 1])
		body.rotation.x += PI / 2

		# fix first joint in place
		if i == 0 && fixed_start:
			joints.append(PinJoint3D.new())
			self.add_child(joints[i])

			joints[i].global_position = points[i]
			joints[0].node_b = segments[0].get_path()
		else:
			joints.append(PinJoint3D.new())
			self.add_child(joints[i])

			joints[i].global_position = points[i]
			joints[i].node_a = segments[i - 1].get_path()
			joints[i].node_b = segments[i].get_path()

	# setup mesh. Create polygon with "mesh_sides" sides that is stretched along a path
	var rope_shape : PackedVector2Array
	for i in mesh_sides:
		rope_shape.append(Vector2(sin(2 * PI * (i + 1) / mesh_sides), cos(2 * PI * ( i + 1 ) / mesh_sides)) * thickness)
	mesh.polygon = rope_shape
	mesh.depth = segment_length

	for joint in joints:
		joint.set("exclude_nodes_from_collision", true)

	if fixed_start:
		var point_to_freeze = curve.get_closest_offset(curve.get_point_position(fixed_start_points))
		for i in range(segments_count):
			if i * segment_length > point_to_freeze:
				break
			segments[i].freeze = true

	if fixed_end:
		joints.append(PinJoint3D.new())
		self.add_child(joints[-1])
		joints[-1].global_position = points[-1]
		joints[-1].node_a = segments[segments_count - 1].get_path()

	if attached_to_start != null:
		joints[0].node_b = attached_to_start.get_path()

	if attached_to_end != null:
		if fixed_end == false:
			joints.append(PinJoint3D.new())
			self.add_child(joints[-1])
			joints[-1].global_position = points[-1]
			joints[-1].node_a = segments[-1].get_path()
		joints[-1].node_b = attached_to_end.get_path()

	for i in range(0, segments.size()):
		max_length += segments[i].get_child(0).shape.height


func _physics_process(_delta: float) -> void:
	# update curve positions
	for p in curve.point_count:
		if  p < (segments_count):
			# new_origin_position + base_origin + half_size == end of element == joint_position
			curve.set_point_position(p, to_local(segments[p].position + segments[p].transform.basis.y * segments[p].get_child(0).shape.height / 2))
		else:
			# for the last segment we do the opposite - find begin of element == joint position
			curve.set_point_position(p, to_local(segments[p - 1].position - segments[p - 1].transform.basis.y * segments[p - 1].get_child(0).shape.height / 2))

	if attached_to_end:
		var start := segments[0].global_position
		var end := attached_to_end.global_position
		var offset := end - start

		# DebugDraw3D.draw_line(segments[0].global_position, attached_to_end.global_position, Color.RED)
		# DebugDraw3D.draw_line(start, start + offset.normalized() * max_length, Color.BLUE)

		if offset.length() > max_length:
			emit_signal("max_extend", start + offset.normalized() * max_length)


func drop_end() -> bool:
	if attached_to_end == null:
		return false

	attached_to_end = null
	self.remove_child(joints.pop_back())

	print("DROPPED")
	return true
