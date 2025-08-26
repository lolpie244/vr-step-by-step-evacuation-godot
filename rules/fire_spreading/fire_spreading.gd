extends Node

func can_burn(tile: Tile) -> bool:
	return !tile.has_flag(Tile.Flags.BURNING) && !tile.has_flag(Tile.Flags.BURNED)

func is_spread(from: Tile, to: Tile, direction: Array[int]) -> bool:
	return randi_range(0, 100) < 30
