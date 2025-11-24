@tool
extends MapBuilderItemCreator


func _get_impl():
	return FireAlarm.new()


func _rotation() -> float:
	return model.global_rotation_degrees.z
