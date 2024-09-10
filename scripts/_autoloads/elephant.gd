extends Node

signal event_logged(p_event: String)

## Elephant is the module that drinks and knows things.
## This scene will check and retain pertinent system and platform info.
## It will also help save and load stuff from disk. It might also be the logger
## module, but that is a lot of things.
@export var save_game_constants: RSaveConstants
var platform_name:= ""
var is_debug_build:= false
var save_time: Dictionary
var config_file_path: String
var logger_file_path: String

func _ready() -> void:
	assert(save_game_constants != null, "Save Game Constants is empty!!")
	is_debug_build = OS.is_debug_build()
	print("Is dev build: ", is_debug_build)
	if is_debug_build == true:
		start_logger()
	# Returns the name of the host OS.
	# Note: Custom builds of the engine may support additional platforms,
	# such as consoles, yielding other return values.
	platform_name = OS.get_name()
	match platform_name:
		"Windows":
			print("Platform: Windows")
		"macOS":
			print("Platform: Mac OS")
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			print("Platform: Linux/BSD")
		"Android":
			print("Platform: Android")
		"iOS":
			print("Platform: iOS")
		"Web":
			print("Platform: Web")
	save_config()
	setup_game_save_dir()
	log_event("All Elephant ready initialization is done!")

func check_dir_exists(p_dir_path: String) -> bool:
	return DirAccess.dir_exists_absolute(p_dir_path)

func setup_logger_dir() -> int:
	if check_dir_exists(save_game_constants.save_log_dir_path) == false:
		var state: Error = DirAccess.make_dir_absolute(save_game_constants.save_log_dir_path)
		if state != OK:
			assert(state == OK, "There was a problem trying to make a directory!!")
			return state
		return 0
	else:
		return 0

func setup_config_dir() -> void:
	if check_dir_exists(save_game_constants.save_config_dir_path) == false:
		var state: Error = DirAccess.make_dir_absolute(save_game_constants.save_config_dir_path)
		if state != OK:
			assert(state == OK, "There was a problem trying to make a directory!!")

func setup_game_save_dir() -> void:
	if check_dir_exists(save_game_constants.save_game_dir_path) == false:
		var state: Error = DirAccess.make_dir_absolute(save_game_constants.save_game_dir_path)
		if state != OK:
			assert(state == OK, "There was a problem trying to make a directory!!")

func read_logger_dir() -> PackedStringArray:
	return _get_dir_contents(save_game_constants.save_log_dir_path)

func read_config_dir() -> PackedStringArray:
	return _get_dir_contents(save_game_constants.save_config_dir_path)

func read_game_save_dir() -> PackedStringArray:
	return _get_dir_contents(save_game_constants.save_game_dir_path)

func _get_dir_contents(p_path: String) -> PackedStringArray:
	var _dir = DirAccess.open(p_path)
	if _dir:
		var string_array: PackedStringArray = _dir.get_files()
		return string_array
	else:
		print("An error occurred when trying to access the path.")
		return PackedStringArray()

func save_config() -> void:
	save_time = Time.get_datetime_dict_from_system()
	setup_config_dir()
	var string_array: PackedStringArray = _get_dir_contents(save_game_constants.save_config_dir_path)
	var config_filename: String = save_game_constants.save_config_default_name + ".dat"
	if string_array.find(config_filename):
		var file = FileAccess.open(save_game_constants.save_config_dir_path + config_filename, FileAccess.WRITE)
		file.store_var(self, true)
	else:
		var file = FileAccess.open(save_game_constants.save_config_dir_path + config_filename, FileAccess.WRITE)
		file.store_var(self, true)

func save_game(p_save_name: String = "") -> void:
	save_time = Time.get_datetime_dict_from_system()
	var save_filename: String
	if p_save_name.is_empty() == true:
		var time_date_stamp: String = Time.get_datetime_string_from_system()
		save_filename = save_game_constants.save_game_default_name + time_date_stamp + ".dat"
	else:
		save_filename = p_save_name + ".dat"
		var string_array: PackedStringArray = _get_dir_contents(save_game_constants.save_game_dir_path)
		if string_array.find(save_filename):
			var file = FileAccess.open(save_game_constants.save_game_dir_path + save_filename, FileAccess.WRITE)
			file.store_var(self, true)
		else:
			printerr("Something bad happened!!")

func load_save():
	pass

func start_logger() -> void:
	save_time = Time.get_datetime_dict_from_system()
	if setup_logger_dir() != 0:
		Elephant.log_event("ERROR: Log dir not set up!")
	var string_array: PackedStringArray = _get_dir_contents(save_game_constants.save_log_dir_path)
	var config_filename: String = save_game_constants.save_log_default_name + ".log"
	logger_file_path = save_game_constants.save_log_dir_path + config_filename
	if string_array.find(config_filename):
		var file = FileAccess.open(logger_file_path, FileAccess.WRITE)
		file.store_var(self, true)
	else:
		var file = FileAccess.open(logger_file_path, FileAccess.WRITE)
		file.store_var(self, true)

func log_event(p_event: String, p_display := false) -> void:
	if is_debug_build:
		save_time = Time.get_datetime_dict_from_system()
		var file = FileAccess.open(logger_file_path, FileAccess.WRITE)
		file.store_string(p_event)
		event_logged.emit(p_event)
		if p_display == true:
			printerr(p_event)
