extends TileMixin

class_name Flammable

@export var material: TileMaterial
@onready var fire: FireEffect = $Fire

var burning: bool = false
var burned: bool = false


func _ready():
	hide()

func init() -> void:
	pass
	#scale(_tile.scale.x)

func cooling_percentage(val):
	fire.cooling_coef = val

func can_burn():
	return !burning && !burned

func ignite():
	burning = true
	_tile.remove_mixin(Walkable)
	show()
