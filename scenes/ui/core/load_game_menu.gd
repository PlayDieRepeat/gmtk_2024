extends Control

signal back_to_start_from_load
signal load_game

func _ready() -> void:
	pass

func _on_load_button_pressed() -> void:
	load_game.emit()

func _on_back_button_pressed() -> void:
	back_to_start_from_load.emit()
