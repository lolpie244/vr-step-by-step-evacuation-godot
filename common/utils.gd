class_name Utils
extends Node

enum Axis { X, Y, Z }

enum Direction { UP, RIGHT, DOWN, LEFT }

const DEFAULT_DUPLICATE = DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS


static func get_matrix(n: int, m: int, fill = null) -> Array:
	var result: Array = Array()
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
	if node.has_method(&"get_aabb"):
		result = result.merge(node.call("get_aabb"))

	for child in node.get_children():
		if is_instance_of(child, Node3D):
			result = _collect_aabb(child, result)

	return result


static func get_aabb(node: Node3D) -> AABB:
	if node.has_method(&"get_aabb"):
		return node.call("get_aabb")
	return _collect_aabb(node, AABB())


static func find_children_with_type(node: Node, type_ref, recursive) -> Array:
	var result: Array = []
	for child in node.get_children():
		if is_instance_of(child, type_ref):
			result.append(child)

		if !recursive:
			continue

		result += find_children_with_type(child, type_ref, recursive)
	return result


static func find_child_with_type(node: Node, type_ref, recursive):
	for child in node.get_children():
		if is_instance_of(child, type_ref):
			return child

		if !recursive:
			continue
		var result = find_child_with_type(child, type_ref, recursive)
		if result != null:
			return result

	return null


static func find_parent_that_implements(node: Node, implements: String):
	if node.get("IMPLEMENTS") == implements:
		return node

	if node.get_parent() == null:
		return null

	return find_parent_that_implements(node.get_parent(), implements)


static func signed_ratio(_min: float, _max: float, value: float) -> float:
	var mid := (_min + _max) / 2.0
	var half_range := (_max - _min) / 2.0
	return (value - mid) / half_range
