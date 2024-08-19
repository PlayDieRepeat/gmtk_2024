extends Node2D

var cell_size: int = 32 # cells are square
var grid_size: Array[int] = [4, 4]
var mouse_position_in_world: Vector2i = Vector2i.ZERO
var grid_position: Vector2i = Vector2i.ZERO
var selected_cell: Vector2i = Vector2i.ZERO
var highlighted_cell: Rect2i = Rect2i(320, 180, 32, 32)


# Called when the node enters the scene tree for the first time.
func _ready():
	_calculate_grid()
	

func _calculate_grid() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _draw():
	draw_rect(highlighted_cell, Color.RED, false, 2)
