extends Control

var woodGained: int = 0
var stoneGained: int = 0
var foodGained: int = 0
var populationGained: int = 0
var favorGained: int = 0
signal continue_game
var stone_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	stone_label = $Panel/VBoxContainer/HBoxContainer/ParticularsSummary/Stone
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_button_button_up():
	if get_tree().paused == true:
		get_tree().paused = false
	queue_free()
