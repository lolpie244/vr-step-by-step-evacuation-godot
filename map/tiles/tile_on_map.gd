extends Node

class_name TileOnMap

var map: Array
var x: int
var y: int
var size: float


func _init(map_: Array, x_: int, y_: int, size_: float):
	self.map = map_
	self.x = x_
	self.y = y_
	self.size = size_
