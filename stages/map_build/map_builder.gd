extends Node

@export var strategic: PackedScene
@onready var map_scanner: MapScanner = $MapScanner

func _ready() -> void:
	map_scanner.start_scan()


func _on_map_scanner_scan_ended(map: Array) -> void:
	
	print("\nResult map:")
	for line in map:
		print(line)

	GameCore.grid.set_tiles(map)
	SceneManager.load_scene(strategic)
