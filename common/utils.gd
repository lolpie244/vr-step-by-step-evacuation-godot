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

static func transpose(arr: Array):
	var new_arr = []

	for i in range(len(arr[0])):
		var row = []
		for j in range(len(arr)):
			row.append(arr[len(arr) - j - 1][i])
		new_arr.append(row)

	return new_arr


