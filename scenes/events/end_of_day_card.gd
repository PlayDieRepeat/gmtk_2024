extends Control
class_name EndOfDayCard

signal card_closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_card() -> void:
	show()

func _on_close_button_pressed() -> void:
	hide()
	card_closed.emit()