extends Node

@export var strategic: PackedScene
@onready var map_scanner: MapScanner = $MapScanner


func _ready() -> void:
	map_scanner.start_scan()


func _on_map_scanner_map_scanned(map: Array) -> void:
	GameCore.grid.set_tiles(map)
	SceneManager.load_scene(strategic)
