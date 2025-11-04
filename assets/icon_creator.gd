@tool
extends SubViewport

@export var size_in_tiles := Vector2i.ONE:
	set(val):
		size_in_tiles = val
		self.size = size_in_tiles * Constants.TILE_SIZE_IN_PX

@export var model_scene: PackedScene:
	set(val):
		model_scene = val
		if not self.is_node_ready():
			return

		for child in model_origin.get_children():
			model_origin.remove_child(child)
			child.free()

		var model: Node3D = model_scene.instantiate()
		model_origin.add_child(model)

		var pos = -Utils.get_aabb(model).get_center()
		model.position = Vector3(pos.x, model.position.y, pos.z)

@export_dir var output_path
@export var file_name := "model"

@export_tool_button("Generate icon") var generate_icon = func():
	assert(model_scene != null, "Model is not assigned")
	assert(output_path != null, "Ouput path is not assigned")

	var output = output_path.path_join(file_name + ".png")
	self.get_texture().get_image().save_png(output)
	print("Image saved to ", output)

@onready var model_origin: Node3D = $ModelOrigin


func _ready() -> void:
	model_scene = model_scene
