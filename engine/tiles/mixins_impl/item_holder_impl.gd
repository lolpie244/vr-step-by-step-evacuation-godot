class_name ItemHolder
extends TileMixin

signal item_placed(item: Item)

var _item: Item
var _is_owner: bool


func init():
	_tile.highlight_changed.connect(_highlight_tiles)


func get_item() -> Item:
	return _item


func can_hold_item(item: Item):
	return (
		(!_item or _item == item)
		and (
			!_tile.get_mixin(Flammable)
			or _tile.get_mixin(Flammable).state == Flammable.State.NOT_BURNING
		)
	)


func place_item(item: Item):
	_is_owner = _tile == item._tile
	_item = item

	if _is_owner:
		item_placed.emit(item)


func _highlight_tiles(val: bool):
	if !_item:
		return

	for tile in _item.tiles():
		if tile.highlight != val:
			tile.highlight = val
