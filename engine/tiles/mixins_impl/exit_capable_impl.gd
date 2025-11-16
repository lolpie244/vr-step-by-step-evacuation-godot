class_name ExitCapable
extends TileMixin


func is_exit():
	return _tile.direct_neighbor_tiles().size() != 4


func init():
	var walkable: Walkable = _tile.get_mixin(Walkable)
	if walkable:
		walkable.character_placed.connect(_on_character_placed)


func _on_character_placed(character: Character):
	if !is_exit():
		return
	character.save()
