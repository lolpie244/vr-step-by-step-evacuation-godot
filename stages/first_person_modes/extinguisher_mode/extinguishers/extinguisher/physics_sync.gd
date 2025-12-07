extends Node

var _is_target_not_picked = func(target, _source) -> bool: return !target.is_picked_up()
var _is_source_picked = func(_target, source) -> bool: return source.is_picked_up()

var _syncable: Array[Sync]

@onready var body: XRToolsPickable = $"../Body"
@onready var lever: XRToolsPickable = $"../HandleOrigin/Pickup"
@onready var hose_end: XRToolsPickable = $"../HoseEndOrigin/Pickup"


func _ready() -> void:
	var hose_end_sync := Sync.new(hose_end, body, _is_target_not_picked)
	hose_end_sync.default_freeze = true

	_syncable = [
		Sync.new(lever, body, _is_target_not_picked),
		Sync.new(body, lever, _is_source_picked),
		hose_end_sync
	]


func _process(_delta):
	for sync in _syncable:
		sync.sync()
