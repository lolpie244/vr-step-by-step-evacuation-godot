extends Node

class_name TileOnGrid

var grid: MapGrid
var x: int
var y: int


func _init(grid_: MapGrid, x_: int, y_: int):
	self.grid = grid_
	self.x = x_
	self.y = y_
