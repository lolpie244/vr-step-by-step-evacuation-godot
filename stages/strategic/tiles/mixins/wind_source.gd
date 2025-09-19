extends Node3D

@onready var tile: TileNode = Utils.find_parent_that_implements(self, "TileNode")
@onready var impl: WindSource = tile.impl.get_or_create_mixin(WindSource)
