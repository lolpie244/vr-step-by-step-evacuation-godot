extends Node

signal character_selected(character: Character)

var grid := MapGrid.new()

var current_turn: int:
	get():
		return _current_turn

var selected_character: Character:
	set(value):
		var old_selected = selected_character
		selected_character = value
		var callable = func(_value = null):
			if selected_character:
				selected_character._highlight(true)

			character_selected.emit(selected_character)

		if old_selected:
			old_selected.highlihted.connect(callable)
			old_selected._is_selected = false
			old_selected._highlight(false)
		else:
			callable.call()

var _current_turn: int = -1


func next_turn():
	_current_turn += 1
	grid.process_turn(_current_turn)
