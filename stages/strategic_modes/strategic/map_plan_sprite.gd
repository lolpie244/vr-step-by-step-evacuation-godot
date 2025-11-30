extends Sprite3D


func _ready() -> void:
	self.texture = ImageTexture.create_from_image(GameCore.evacuation_plan)
