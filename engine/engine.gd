extends Node

var grid := MapGrid.new()

var current_turn: int:
	get():
		return _current_turn

var _current_turn: int = -1


func next_turn():
	_current_turn += 1
	grid.process_turn(_current_turn)
