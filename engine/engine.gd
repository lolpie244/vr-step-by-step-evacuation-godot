extends Node

signal character_selected(character: Character)
signal alarm_triggered

var evacuation_plan: Image
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
var _alarm_triggered: bool = false


func next_turn():
	_current_turn += 1
	var timer := Metrics.start_timer("Turn")
	grid.process_turn(_current_turn)
	timer.stop()


func set_grid(new_grid: MapGrid):
	for signal_info in grid.get_signal_list():
		for connection in grid.get_signal_connection_list(signal_info["name"]):
			new_grid.connect(signal_info["name"], connection["callable"])
			grid.disconnect(signal_info["name"], connection["callable"])

	grid = new_grid


func trigger_alarm():
	if _alarm_triggered:
		return
	_alarm_triggered = true
	alarm_triggered.emit()


func reset():
	_alarm_triggered = false
	_current_turn = -1
	selected_character = null
	grid.reset()
