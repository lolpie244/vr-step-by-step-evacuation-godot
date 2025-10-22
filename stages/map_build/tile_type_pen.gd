@tool
class_name TileTypePen
extends Node3D

signal type_changed(type: Tile.Type, pos: Vector2i)

@export var type: Tile.Type
@export var color: Color

@onready var pen_body: MeshInstance3D = $Body/Mesh
@onready var snap_zone: XRToolsSnapZone = $SnapZone


func _ready():
	if color:
		var material: StandardMaterial3D = pen_body.get_surface_override_material(0)
		material.albedo_color = color
		pen_body.set_surface_override_material(0, material)


func _on_body_dropped(pickable: Variant) -> void:
	snap_zone.pick_up_object(pickable)


func _on_area_entered(body: Area3D) -> void:
	if not body is Tile2D:
		return
	var tile := body as Tile2D
	if tile.impl.type != type:
		type_changed.emit(type, tile.impl.pos)
	pass # Replace with function body.
