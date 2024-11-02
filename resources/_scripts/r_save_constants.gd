extends Resource
class_name RSaveConstants

@export var save_game_dir_path := ""
@export var save_config_dir_path := ""
@export var save_log_dir_path := ""
@export var save_game_default_name := ""
@export var save_config_default_name := ""
@export var save_log_default_name := ""
@export var auto_save_on_timer := false
@export var auto_save_timer := 3000000

func _init(p_save_game_dir_path := "", p_save_config_dir_path := "",
			p_save_log_dir_path := "", p_save_game_default_name := "",
			p_save_config_default_name := "", p_save_log_default_name := "",
			p_auto_save_on_timer := false, p_auto_save_timer := 0) -> void:
	save_game_dir_path = p_save_game_dir_path
	save_config_dir_path = p_save_config_dir_path
	save_log_dir_path = p_save_log_dir_path
	save_game_default_name = p_save_game_default_name
	save_config_default_name = p_save_config_default_name
	save_log_default_name = p_save_log_default_name
	auto_save_on_timer = p_auto_save_on_timer
	auto_save_timer = p_auto_save_timer
