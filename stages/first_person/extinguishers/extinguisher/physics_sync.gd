extends Node

var _is_target_not_picked = func(target, _source) -> bool: return !target.is_picked_up()
var _is_source_picked = func(_target, source) -> bool: return source.is_picked_up()

@onready var body: XRToolsPickable = $"../Body"
@onready var lever: XRToolsPickable = $"../HandleOrigin/Pickup"
@onready var hose_end: XRToolsPickable = $"../HoseEndOrigin/Pickup"

@onready var _syncable: Array[Sync] = [
	Sync.new(lever, body, _is_target_not_picked),
	Sync.new(hose_end, body, _is_target_not_picked),
	Sync.new(body, lever, _is_source_picked),
]


func _process(_delta):
	for sync in _syncable:
		sync.sync()
