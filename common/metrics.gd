class ExecutionTimer:
	var _start: float
	var _end

	var _name: String
	var _message: String

	func _init(name: String, message := "{0} {1} ms"):
		_name = name
		_message = message

	func start():
		_start = Time.get_ticks_msec()
		_end = null

	func stop():
		if _end:
			return
		_end = Time.get_ticks_msec()
		Metrics._publish("Timer", _message.format([_name, _end - _start]))

	func _notification(what):
		if what == NOTIFICATION_PREDELETE:
			stop()


var enabled: bool = true:
	set(val):
		enabled = val
		_ready()


func _ready():
	if !enabled:
		return
	start_fps_counter()


func _publish(topic: String, message):
	if !enabled:
		return

	print("[METRICS] {0}: {1}".format([topic, message]))


func start_timer(name: String, message = "{0} {1} ms") -> ExecutionTimer:
	var timer := ExecutionTimer.new(name, message)
	timer.start()

	return timer


func start_fps_counter():
	while enabled:
		await Engine.get_main_loop().create_timer(Constants.METRICS_FPS_PUBLISH_FREQUENCY).timeout
		var name = SceneManager.current_scene.get("IMPLEMENTS")
		if !name:
			name = "Unknown"

		_publish("fps", "{0} {1}".format([name, Engine.get_frames_per_second()]))
