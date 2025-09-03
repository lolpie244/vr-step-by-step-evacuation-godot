@tool
extends GridItemFactory
class_name TileFactory

enum Type {
	None,
	Floor,
	Wall,
	Door,
	Window,
	Staircase,
}

@export var properties: Array[Tile.Flags] = []
@export var type: Type = Type.None
@export var material: TileMaterial


func _create_shared_data():
	return SharedData.new(self)


class SharedData:
	var flags: int = 0
	var model: Node3D
	var animation: AnimationPlayer
	var material: TileMaterial

	func _init(fabric) -> void:
		for property in fabric.properties:
			flags |= property

		material = fabric.material

		model = fabric.get_node("model")
		animation = fabric.get_node_or_null("animation")
