extends Control

signal back_to_start

func _on_return_button_pressed() -> void:
	emit_signal("back_to_start")
