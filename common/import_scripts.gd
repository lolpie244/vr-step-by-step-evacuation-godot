@tool

extends EditorScenePostImport


func _post_import(scene):
	var new_root: Node = scene.get_child(0)
	new_root.name = scene.name

	_set_new_owner(new_root, new_root)

	return new_root


func _set_new_owner(node: Node, owner: Node):
	# If we set a node's owner to itself, we'll get an error
	if node != owner:
		node.owner = owner

	for child in node.get_children():
		_set_new_owner(child, owner)
