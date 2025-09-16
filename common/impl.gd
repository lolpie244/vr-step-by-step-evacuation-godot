extends Node3D
class_name BaseImpl

var instance = self

func set_instance(instance_):
	instance = instance_
	_redirect_signals(instance_)


func _redirect_signals(redirect_to):
	for signal_info in get_signal_list():
		var signal_name: String = signal_info["name"]
		for connection in get_signal_connection_list(signal_name):
			var callable: Callable = connection["callable"]
			var flags: int = int(connection.get("flags", 0))

			redirect_to.connect(signal_name, callable, flags)
