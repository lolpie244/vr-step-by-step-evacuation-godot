extends XRController3D

var rumble_strength: float:
	set(val):
		_rumbler.event.magnitude = clamp(val, 0, 1)

var is_rumbling: bool = false
@onready var _rumbler: XRToolsRumbler = $Rumbler


func _ready() -> void:
	_rumbler.target = self


func start_rumble(duration_ms: int = 0):
	if is_rumbling:
		return

	if duration_ms == 0:
		_rumbler.event.indefinite = true
		_rumbler.event.duration_ms = 0
	else:
		_rumbler.event.indefinite = false
		_rumbler.event.duration_ms = duration_ms
		(
			(func():
				await Engine.get_main_loop().create_timer(duration_ms * 0.001).timeout
				is_rumbling = false)
			. call()
		)

	_rumbler.rumble()


func stop_rumble():
	if not is_rumbling:
		return
	is_rumbling = false
	_rumbler.cancel()
