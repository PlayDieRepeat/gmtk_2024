extends Node
## This scene will check and retain pertinent system and platform info
var platform_name := ""
var is_debug_build := false

func _ready() -> void:
	is_debug_build = OS.is_debug_build()
	print("Is dev build: ", is_debug_build)
	
	platform_name = OS.get_name()
	match platform_name:
		"Windows":
			print("Platform: Windows")
		"macOS":
			print("Platform: Mac OS")
		"Web":
			print("Platform: Web")
