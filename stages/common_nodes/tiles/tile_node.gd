class_name TileNode
extends Node3D
const IMPLEMENTS := "TileNode"

@export var type: Tile.Type = Tile.Type.NONE

var impl: Tile


func set_impl(_impl: Tile):
	impl = _impl


func init():
	visible = true
	impl.init()

	for model in Utils.find_children_with_type(self, TileMesh, false):
		var new_model = (model as TileMesh).get_transformed(impl)
		self.remove_child(model)
		self.add_child(new_model)
		model.free()


func size() -> Vector3:
	return Utils.get_aabb(self).size * self.scale.x
