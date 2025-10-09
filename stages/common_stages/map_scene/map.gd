class_name Map
extends MeshInstance3D

@export var cutoff_shader: Shader
var cutoff_material: ShaderMaterial

var zoom: float:
	get():
		return map_items.scale.x
	set(new_zoom):
		if new_zoom <= 0:
			return
		map_items.scale = Vector3.ONE * new_zoom

var offset: Vector2:
	get():
		return Vector2(map_items.position.x, map_items.position.z)
	set(new_offset):
		map_items.position.x = new_offset.x
		map_items.position.z = new_offset.y

var _tile_size: float

@onready var impl: MapGrid = GameCore.grid
@onready var map_items = $MapItems


func _ready() -> void:
	impl.resized.connect(set_size)

	var plane_mesh := self.mesh as PlaneMesh
	plane_mesh.size = Vector2(
		self.get_aabb().size.x * self.scale.x, self.get_aabb().size.z * self.scale.z
	)
	self.scale = Vector3.ONE

	var plane_pos = global_transform.origin
	cutoff_material = ShaderMaterial.new()
	cutoff_material.shader = cutoff_shader
	cutoff_material.set_shader_parameter("plane_size", plane_mesh.size * 0.5)
	cutoff_material.set_shader_parameter("plane_pos", Vector2(plane_pos.x, plane_pos.z))
	cutoff_material.set_shader_parameter("border_color", Color.RED)


func add_item(node: Node3D):
	map_items.add_child(node)
	node.set_material(self.cutoff_material)


func place_item(node: Node3D, x: int, y: int):
	node.position = (
		Vector3(_tile_size * x, 0, _tile_size * y)
		- (Vector3(impl.grid.rows_count(), 0, impl.grid.columns_count()) * _tile_size / 2)
		+ Vector3(_tile_size, 0, _tile_size) / 2
	)

	node.scale = Vector3.ONE * Utils.get_aabb(node).size


func set_size(size: Vector2):
	_tile_size = min(self.get_aabb().size.x / size.x, self.get_aabb().size.z / size.y)
