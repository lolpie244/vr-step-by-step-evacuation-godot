@tool
class_name WallItemNode
extends ItemNode


func _on_placed(_tile: Tile):
	show()
	match impl().get_direction():
		Utils.Direction.DOWN:
			self.position.z = -self.position.z
		Utils.Direction.LEFT:
			self.position.x = self.position.z
		Utils.Direction.RIGHT:
			self.position.x = -self.position.z
