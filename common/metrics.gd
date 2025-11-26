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
		Metrics._publish("timer", {"name": _name, "time_ms": _end - _start, "details": _details})


var enabled: bool = true

var _http := RESTClient.new()
var _client_id: int
var _fps: float = -1


func init():
	if !enabled:
		return

	if Constants.SEND_METRICS:
		await _http.connect_to_server(Constants.METRICS_SERVER)
		_client_id = await _get_client_id()
	start_fps_counter()


func reset_fps_counter():
	_fps = -1


func start_timer(timer_name: String, details = "") -> ExecutionTimer:
	var timer := ExecutionTimer.new(timer_name, details)
	timer.start()

	return timer


func start_fps_counter():
	while enabled:
		await Engine.get_main_loop().create_timer(Constants.METRICS_FPS_PUBLISH_FREQUENCY).timeout
		_publish("fps", {"fps": _fps})
		reset_fps_counter()


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

	_http.post("/{0}".format([topic]), message)
