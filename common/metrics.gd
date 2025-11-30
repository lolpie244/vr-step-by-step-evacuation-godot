extends Node


class ExecutionTimer:
	var _start: float
	var _end

	var _name: String
	var _details: String

	func _init(name: String, details = ""):
		_name = name
		_details = details

	func start():
		_start = Time.get_ticks_msec()
		_end = null

	func stop():
		if _end:
			return
		_end = Time.get_ticks_msec()
		Metrics._timers.append({"name": _name, "time_ms": _end - _start, "details": _details})


var enabled: bool = true

var _http := RESTClient.new()
var _client_id: int
var _fps: float = -1
var _timers: Array[Dictionary] = []


func init():
	if !enabled:
		return

	if Constants.SEND_METRICS:
		await _http.connect_to_server(Constants.METRICS_SERVER)
		_client_id = await _get_client_id()
	start_event_loop()


func reset_fps_counter():
	_fps = -1


func start_timer(timer_name: String, details = "") -> ExecutionTimer:
	var timer := ExecutionTimer.new(timer_name, details)
	timer.start()

	return timer


func start_event_loop():
	while enabled:
		await Engine.get_main_loop().create_timer(Constants.METRICS_PUBLISH_FREQUENCY).timeout
		await _publish("fps", {"fps": _fps})
		reset_fps_counter()

		if _timers:
			await _publish_batch("timer", _timers)
			_timers.clear()


func _process(_delta):
	if _fps < 0:
		_fps = Engine.get_frames_per_second()
	_fps = (_fps + Engine.get_frames_per_second()) / 2.0


func _get_client_id() -> int:
	if !_http.is_valid():
		return 0
	var payload: Dictionary = {"device": OpenXRMetaHeadsetIDExtensionWrapper.get_headset_id()}
	return (await _http.post("/client", payload)).get("id", 0)


func _publish(topic: String, message: Dictionary):
	if !enabled:
		return

	message["scene"] = SceneManager.current_scene.get("IMPLEMENTS")
	message["client_id"] = _client_id

	if !_http.is_valid():
		print("[METRICS] {0}: {1}".format([topic, message]))
		return

	await _http.post("/{0}".format([topic]), message)


func _publish_batch(topic: String, messages: Array[Dictionary]):
	if !enabled:
		return

	for message in messages:
		message["scene"] = SceneManager.current_scene.get("IMPLEMENTS")
		message["client_id"] = _client_id

	if !_http.is_valid():
		print("[METRICS] {0}: ".format([topic]), messages)
		return

	await _http.post("/{0}/batch".format([topic]), messages)
