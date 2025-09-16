@tool
extends GridItemFactory
class_name CharacterFactory

enum Type { Civilian }

@export var type: Type = Type.Civilian
@export_range(1, 100) var default_speed: int = 1

func _create_shared_data():
	return SharedData.new(self)

func create(grid_: MapGrid, x_: int, y_: int):
	var result = super.create(grid_, x_, y_)
	result.add_child($PickableObject.duplicate())

	return result

class SharedData:
	var character_body: Node3D
	var default_speed: int
	var pickable: Node3D

	func _init(factory: CharacterFactory):
		character_body = factory.get_node("character_body")
		default_speed = factory.default_speed
