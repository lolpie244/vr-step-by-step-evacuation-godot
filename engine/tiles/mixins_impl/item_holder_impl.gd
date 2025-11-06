class_name ItemHolder
extends TileMixin

signal item_placed(item: Item)
signal item_removed(item: Item)

var _item: Item
var _is_owner: bool


func init():
	_tile.highlight_changed.connect(_highlight_tiles)


func get_item() -> Item:
	return _item


func has_item() -> bool:
	return _item != null


func can_hold_item(item: Item):
	return (
		(!_item or _item == item)
		and (
			!_tile.get_mixin(Flammable)
			or _tile.get_mixin(Flammable).state == Flammable.State.NOT_BURNING
		)
	)


func place_item(item: Item):
	_update_walkable()
	if item != _item:
		_is_owner = _tile == item._tile
		_item = item
		_item.removed.connect(_on_item_removed)

	if _is_owner:
		item_placed.emit(item)


func remove_item():
	if !has_item():
		return
	_item.remove()
	_update_walkable()


func _on_item_removed(item: Item):
	_item = null
	if _is_owner:
		item_removed.emit(item)


func _highlight_tiles(val: bool):
	if !_item:
		return

	for tile in _item.tiles():
		if tile.highlight != val:
			tile.highlight = val


func _update_walkable():
	var walkable: Walkable = _tile.get_mixin(Walkable)
	if walkable:
		walkable.set_blocker(self, self.has_item())
