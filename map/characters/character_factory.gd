@tool
extends GridItemFactory
class_name CharacterFactory

enum Type { Civilian }

@export var type: Type = Type.Civilian
@export_range(1, 100) var default_speed: int = 1

func _create_shared_data():
	return SharedData.new(self)


class SharedData:
	var character_body: CharacterBody3D
	var default_speed: float

	func _init(factory: CharacterFactory):
		character_body = factory.get_node("character_body")
		default_speed = factory.default_speed
