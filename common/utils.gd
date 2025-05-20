extends Node

class_name Utils


static func get_matrix(n: int, m: int, fill = null):
	var result = Array()
	result.resize(n)

	for i in result.size():
		result[i] = Array()
		result[i].resize(m)
		result[i].fill(fill)

	return result

