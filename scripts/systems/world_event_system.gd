extends Node

@export var end_of_day_card: PackedScene
#preload("res://scenes/systems/end_of_day_card.tscn")
var eod_card_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_world_controller_new_day(_p_new_day: int, _p_old_day: int, _p_time_constants: RTimeConstants) -> void:
	get_tree().paused = true
	#Get all end of day event data
	var woodGained: int = 12
	var stoneGained: int = 16
	var foodGained: int = 30
	var populationGained: int = 7
	var favorGained: int = 210
	
	#Pop card
	eod_card_instance = end_of_day_card.instantiate()
	add_child(eod_card_instance)

	#Push event data to card
	eod_card_instance.woodGained = woodGained
	eod_card_instance.stoneGained = stoneGained
	eod_card_instance.foodGained = foodGained
	eod_card_instance.populationGained = populationGained
	eod_card_instance.favorGained = favorGained
