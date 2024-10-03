class_name WorldController
extends Node

@export var time_constants: RTimeConstants
@export var god_data: RGod

var world_timer: Timer
var seconds_count: int = 0
var hour_count: int = 0
var day_count: int = 0

signal new_day(p_new_day: int, p_old_day: int, p_time_constants: RTimeConstants)
signal new_hour(p_new_hour: int, p_old_hour: int, p_time_constants: RTimeConstants)
signal set_god(p_god_data: RGod)

func _ready():
	#_load_all_resources()
	#ui_time = $CanvasLayer/MarginContainer/VBoxContainer/Time
	#ui_tithing = $CanvasLayer/MarginContainer/VBoxContainer/Tithing
	#ui_tithing.text = "Tithing: "
	#ui_favor = $CanvasLayer/MarginContainer/VBoxContainer/Favor
	#ui_favor.text = "Favor: "
	#var god_background: TextureRect = $ParallaxBackground/GodLayer/GodImage
	#var new_god: RGod = ResourceLoader.load("res://resources/gods/cat_god.tres", "RGod")
	#%God.set_god(new_god)
	#god_background.texture = %God.god_data.image
	#hour_count = time_constant.start_of_day
	#$ParallaxBackground/AlphaLayer/AlphaImage.self_modulate.a = alpha_float
	#var margin_value: int = 15
	#$CanvasLayer/MarginContainer.add_theme_constant_override("margin_left", margin_value)
	#alpha_change_float = alpha_float/(time_constant.seconds_in_hour*6)
	# Required resources should be asserted at ready to stop us from doing bad things
	assert(time_constants != null, "Time Constants not set in WorldController")
	assert(god_data != null, "No default God Data set in WorldController")

	# Store reference to world_timer and connect signal
	# TODO - Should we just instantiate the Timer here as a node? think it depends how we handle time going forward.
	world_timer = %WorldTimer
	world_timer.timeout.connect(_on_timer_timeout)

	hour_count = time_constants.start_of_day
	new_hour.emit(hour_count, 0, time_constants)
	set_god.emit(god_data)

func _on_timer_timeout():
	seconds_count += 1

	if seconds_count >= time_constants.seconds_in_hour:
		_update_hour_count()
		seconds_count = 0
	if hour_count >= time_constants.end_of_day:
		_update_day_count()
		hour_count = time_constants.start_of_day

func _update_hour_count() -> void:
	var previous_hour_count := hour_count
	hour_count += 1
	new_hour.emit(hour_count, previous_hour_count, time_constants)

func _update_day_count() -> void:
	var previous_day_count := hour_count
	day_count += 1
	new_day.emit(day_count, previous_day_count, time_constants)
