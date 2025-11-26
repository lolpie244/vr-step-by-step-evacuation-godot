class_name RESTClient

var _http: HTTPClient


func is_valid() -> bool:
	return _http != null and _http.get_status() != HTTPClient.STATUS_DISCONNECTED


func connect_to_server(url: String, port: int = -1):
	var http := HTTPClient.new()
	if http.connect_to_host(url, port) != OK:
		printerr("Failed to connect to host")
		return

	while http.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		http.poll()
		await Engine.get_main_loop().process_frame

	if http.get_status() != HTTPClient.STATUS_CONNECTED:
		printerr("RESTClient, incorrect status: ", http.get_status())
		return

	_http = http


func _receive() -> Dictionary:
	while _http.get_status() == HTTPClient.STATUS_REQUESTING:
		_http.poll()
		await Engine.get_main_loop().process_frame

	if !_http.has_response():
		return {}

	var rb := PackedByteArray()
	while _http.get_status() == HTTPClient.STATUS_BODY:
		# While there is body left to be read
		_http.poll()
		# Get a chunk.
		var chunk = _http.read_response_body_chunk()
		if chunk.size() == 0:
			await Engine.get_main_loop().process_frame
		else:
			rb = rb + chunk  # Append to read buffer.

	var json := JSON.new()
	json.parse(rb.get_string_from_utf8())

	if !json.get_data():
		return {}
	return json.get_data()


func _wait():
	while _http.get_status() in [HTTPClient.STATUS_REQUESTING, HTTPClient.STATUS_BODY]:
		_http.poll()
		await Engine.get_main_loop().process_frame


func post(url: String, payload: Dictionary) -> Dictionary:
	if !is_valid():
		return {}
	await _wait()
	_http.request(HTTPClient.METHOD_POST, url, [], JSON.stringify(payload))
	return await _receive()
