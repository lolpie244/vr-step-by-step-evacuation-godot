@tool
extends GridItemFactory
class_name CharacterFactory

enum Type { Civilian }

@export var type: Type = Type.Civilian

func _create_shared_data():
	return SharedData.new(self)


class SharedData:
	var character_body: CharacterBody3D

	func _init(factory: CharacterFactory):
		character_body = factory.get_node("character_body")
