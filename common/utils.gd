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

static func _collect_aabb(node: Node3D, result: AABB) -> AABB:
	if node.has_method(&'get_aabb'):
		result = result.merge(node.call('get_aabb'))

	for child in node.get_children():
		if is_instance_of(child, Node3D):
			result = _collect_aabb(child, result)

	return result

static func get_aabb(node: Node3D) -> AABB:
	if node.has_method(&'get_aabb'):
		return node.call('get_aabb')
	return _collect_aabb(node, AABB())
