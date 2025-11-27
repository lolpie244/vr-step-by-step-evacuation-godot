class_name Visible
extends TileMixin

signal visible_changed(value: bool)

var _visible_by: Array[Character] = []


func init():
	var flammable: Flammable = _tile.get_mixin(Flammable)
	var smokable: Smokable = _tile.get_mixin(Smokable)
	var blockable: Blockable = _tile.get_mixin(Blockable)

	if flammable:
		flammable.state_changed.connect(_on_flammable_state_changed)

	if smokable:
		smokable.state_changed.connect(_on_smokable_state_changed)

	if blockable:
		blockable.blocking_changed.connect(_on_blockable_changed)

	visible_changed.connect(_on_visible_changed)


func is_visible() -> bool:
	return _visible_by.size() != 0


func set_visible(by: Character, visible: bool):
	var previous_state := is_visible()

	if visible and not by in _visible_by:
		_visible_by.append(by)
	if !visible:
		_visible_by.erase(by)

	# call_deffered, because we can remove and add the same tile from visible in single frame
	(
		(func():
			if is_visible() != previous_state:
				visible_changed.emit(is_visible()))
		. call_deferred()
	)


func _on_flammable_state_changed(_flammable: Flammable, state: Flammable.State):
	if state == Flammable.State.BURNING:
		for character in _visible_by:
			character.enabled = true


func _on_smokable_state_changed(_smokable: Smokable, state: Smokable.State):
	if state == Smokable.State.SMOKE:
		for character in _visible_by:
			character.enabled = true


func _on_blockable_changed(_is_blocking: bool):
	for character in _visible_by:
		character.reset_visible()


func _on_visible_changed(value: bool):
	if !value:
		return

	var walkable: Walkable = _tile.get_mixin(Walkable)
	if walkable and walkable.get_character():
		walkable.get_character().enabled = true
