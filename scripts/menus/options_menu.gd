extends Control

signal back_to_start_from_options

func _ready() -> void:
	for i in %Tabs.get_tab_count():
		if %Tabs.get_tab_title(i) == "MainOptionsPanel":
			%Tabs.set_tab_title(i, "Main")
		if %Tabs.get_tab_title(i) == "SoundsOptionsPanel":
			%Tabs.set_tab_title(i, "Sounds")
		if %Tabs.get_tab_title(i) == "ControlsOptionsPanel":
			%Tabs.set_tab_title(i, "Controls")

func _on_back_button_pressed() -> void:
	emit_signal("back_to_start_from_options")
