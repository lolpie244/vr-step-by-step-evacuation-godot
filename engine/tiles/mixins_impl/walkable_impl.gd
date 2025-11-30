class_name Walkable
extends TileMixin

signal character_placed(character: Character)
signal character_removed(character: Character)
signal enabled_changed(value: bool)

var enabled: bool:
	get():
		return _blockers.size() == 0

var _character: Character
var _blockers: Array
var _reachable_by: Array[Character]


func init():
	var flammable: Flammable = _tile.get_mixin(Flammable)
	if flammable:
		flammable.state_changed.connect(_on_flammable_state_changed)

	enabled_changed.connect(_on_enabled_changed)


func get_character() -> Character:
	return _character


func place_character(character: Character) -> bool:
	if _character != character:
		_character = character
		_character.tile_changed.connect(_on_character_tile_changed)
		_character.death.connect(_on_character_death)
		_character.saved.connect(_on_character_saved)
		set_reachable(character, true)

	set_blocker(self, true)
	character_placed.emit(_character)

	return true


class ReachableResult:
	var tile: Tile
	var distance: int
	var direction: Vector2

	func _init(_tile: Tile, _distance: int, _direction: Vector2):
		tile = _tile
		distance = _distance
		direction = Vector2(_direction.y, _direction.x)


func reachable_neighbors() -> Array[Walkable]:
	var result: Array[Walkable] = []

	for tile in _tile.direct_neighbor_tiles():
		if is_walkable(tile):
			result.append(tile.get_mixin(Walkable))

	return result


func reachable_tiles(_speed: int) -> Array[ReachableResult]:
	var result: Array[ReachableResult] = []

	var queue := [[get_tile(), _speed]]
	var used := {}

	while queue.size():
		var info = queue.pop_front()
		var current_walkable: Walkable = info[0].get_mixin(Walkable)
		var speed: int = info[1]

		if speed <= 0:
			continue

		for walkable in current_walkable.reachable_neighbors():
			var tile := walkable.get_tile()
			if used.has(tile.get_instance_id()):
				continue
			result.append(
				ReachableResult.new(
					tile, _speed - speed + 1, current_walkable.get_tile().direction_to(tile)
				)
			)

			used[tile.get_instance_id()] = true
			queue.append([tile, speed - 1])

	return result


static func is_walkable(tile: Tile):
	return tile and tile.get_mixin(Walkable) and tile.get_mixin(Walkable).enabled


func set_blocker(blocker, is_blocking: bool):
	var old_state := enabled
	if is_blocking:
		if not blocker in _blockers:
			_blockers.append(blocker)
	else:
		_blockers.erase(blocker)

	if enabled != old_state:
		enabled_changed.emit(enabled)


func remove_character():
	if !_character:
		return
	_character.death.disconnect(_on_character_death)
	_character.saved.disconnect(_on_character_saved)

	set_blocker(self, false)
	character_removed.emit(_character)

	_character = null


func set_reachable(by: Character, reachable: bool):
	if reachable and not by in _reachable_by:
		_reachable_by.append(by)
	if !reachable:
		_reachable_by.erase(by)


func _on_character_tile_changed(tile: Tile):
	if tile == _tile:
		return

	remove_character()


func _on_character_death(character: Character):
	if character == _character:
		remove_character()


func _on_character_saved(character: Character):
	if character == _character:
		remove_character()


func _on_flammable_state_changed(_flammable: Flammable, state: Flammable.State):
	if !_character:
		return

	if state == Flammable.State.BURNING:
		_character.kill()


func _on_enabled_changed(_value: bool):
	for tile in _tile.direct_neighbor_tiles():
		var walkable: Walkable = tile.get_mixin(Walkable)
		if walkable:
			for character in walkable._reachable_by:
				if character.get_tile():
					character.reset_reachable()
