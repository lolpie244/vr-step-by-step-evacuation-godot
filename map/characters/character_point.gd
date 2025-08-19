extends Node3D
class_name CharacterPoint

@onready var Point = $Point

func place_character(character: Character):
	character.transform *= Point.transform
