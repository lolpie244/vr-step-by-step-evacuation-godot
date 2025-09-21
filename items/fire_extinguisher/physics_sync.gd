extends Node3D

@export_node_path var body_path
@export_node_path var lever_path
@export_node_path var hose_end_path

var _is_target_not_picked = func(target, _source) -> bool: return !target.is_picked_up()

var _is_source_picked = func(_target, source) -> bool: return source.is_picked_up()

@onready var body := get_node(body_path) as XRToolsPickable
@onready var lever := get_node(lever_path) as XRToolsPickable
@onready var hose_end := get_node(hose_end_path) as HoseEnd

@onready var _syncable: Array[Sync] = [
	Sync.new(lever, body, _is_target_not_picked),
	Sync.new(hose_end, body, _is_target_not_picked),
	Sync.new(body, lever, _is_source_picked),
]


func _process(_delta):
	for sync in _syncable:
		sync.sync()
