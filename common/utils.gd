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


static func find_child_with_type(node: Node, type_ref, recursive):
	for child in node.get_children():
		if is_instance_of(child, type_ref):
			return child

		if !recursive:
			continue

		var grandchild = find_child_with_type(child, type_ref, recursive)
		if grandchild != null:
			return grandchild
	return null

static func find_children_with_type(node: Node, type_ref, recursive) -> Array:
	var result : Array = []
	for child in node.get_children():
		if is_instance_of(child, type_ref):
			result.append(child)

		if !recursive:
			continue

		result += find_children_with_type(child, type_ref, recursive)
	return result

static func find_parent_with_type(node: Node, type_ref):
	if is_instance_of(node, type_ref):
		return node

	if node.get_parent() == null:
		return null

	return find_parent_with_type(node.get_parent(), type_ref)


static func find_parent_that_implements(node: Node, implements: String):
	if node.get("_implements") == implements:
		return node

	if node.get_parent() == null:
		return null

	return find_parent_that_implements(node.get_parent(), implements)


const DEFAULT_DUPLICATE = DUPLICATE_SCRIPTS | DUPLICATE_GROUPS | DUPLICATE_SIGNALS


static func signed_ratio(min_: float, max_: float, value: float) -> float:
	var mid := (min_ + max_) / 2.0
	var half_range := (max_ - min_) / 2.0
	return (value - mid) / half_range
