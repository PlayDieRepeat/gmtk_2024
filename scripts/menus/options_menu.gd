extends Control

signal back_to_start_from_options

func _on_back_button_pressed() -> void:
	emit_signal("back_to_start_from_options")
