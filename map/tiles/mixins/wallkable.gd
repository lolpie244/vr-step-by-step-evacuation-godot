extends Node3D

class_name Wallkable

@onready var _tile: Tile = Utils.find_parent_with_type(self, Tile)

func _ready():
	self.hide()

func place_character(character: Character) -> bool:
	if character.get_parent() == null:
		_tile.add_child(character)

	if character.get_parent() != _tile:
		character.reparent(_tile)

	print(self.position)
	character.position = self.position
	# character.transform = self.transform
	character._x = _tile.pos.x
	character._y = _tile.pos.y

	return true
