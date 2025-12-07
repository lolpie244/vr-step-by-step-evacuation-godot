extends Node3D

const TEST_MAP_TYPES := [
	# 0    1    2    3    4
	["w", "w", "w", "w", "w"],  # 0
	["w", "f", "f", "f", "w"],  # 1
	["w", "f", "f", "f", "w"],  # 2
	["w", "f", "f", "f", "w"],  # 3
	["w", "w", "w", "w", "w"],  # 4
]

const TYPE_MAPPING := {
	" ": Tile.Type.NONE,
	"f": Tile.Type.FLOOR,
	"w": Tile.Type.WALL,
	"o": Tile.Type.WINDOW,
	"d": Tile.Type.DOOR,
}

@export var next_scene: PackedScene

var secondary_item: Item

var lamp: Furniture
var couch: Furniture
var table: Furniture

@onready var map: StrategicMap = $Map
@onready var impl: MapGrid = map.impl

@onready var label: Label = $CanvasLayer/Label


func restore():
	GameCore.reset()

	for x in range(impl.size.x):
		for y in range(impl.size.y):
			var tile_impl: Tile = impl.create_tile(TYPE_MAPPING[TEST_MAP_TYPES[x][y]], x, y)
			tile_impl.get_or_create_mixin(ItemHolder)
			tile_impl.get_or_create_mixin(Flammable)

	lamp = Furniture.new(Furniture.Type.LAMP, Vector2.ONE)
	impl.add_item(lamp)

	couch = Furniture.new(Furniture.Type.COUCH, Vector2(2, 1))
	couch.material = load("res://engine/fire_spreading/materials/polyurethane_foam.tres")
	impl.add_item(couch)

	table = Furniture.new(Furniture.Type.TABLE, Vector2(1, 1))
	table.material = load("res://engine/fire_spreading/materials/engineered_wood.tres")
	impl.add_item(table)

	lamp.place(impl.get_tile(2, 3), Utils.Direction.UP)

	couch.place(impl.get_tile(2, 1), Utils.Direction.RIGHT)
	secondary_item = couch

	#table.place(impl.get_tile(2, 2), Utils.Direction.UP)
	#secondary_item = table

	lamp.main_tile().get_mixin(Flammable).ignite()
	map.reset_map()
	GameCore.next_turn()


func manual_test():
	restore()
	map.reset_map()
	for a in map._tile_nodes:
		for node in a:
			node.show()


func fire_spreading_automate_test(n = 100):
	var result: float = -1
	for x in range(n):
		print(x)
		restore()

		for i in range(1, 100):
			GameCore.next_turn()
			if secondary_item.main_tile().get_mixin(Flammable).state == Flammable.State.BURNING:
				if result == -1:
					result = i
				result = (result + i) / 2.0
				break

	print("-----")
	print(result)


func _ready() -> void:
	seed(45)
	Metrics.enabled = false
	map.set_size(Vector2(TEST_MAP_TYPES.size(), TEST_MAP_TYPES[0].size()))

	manual_test()
	#fire_spreading_automate_test(500)


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("right"):
		GameCore.next_turn()
		if secondary_item.main_tile().get_mixin(Flammable).state != Flammable.State.BURNING:
			label.text = str(GameCore._current_turn)
