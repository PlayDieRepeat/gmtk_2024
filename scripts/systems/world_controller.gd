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
	# Required resources should be asserted at ready to stop us from doing bad things
	assert(time_constants != null, "Time Constants not set in WorldController")
	assert(god_data != null, "No default God Data set in WorldController")

	# Store reference to world_timer and connect signal
	# TODO - Should we just instantiate the Timer here as a node? think it depends how we handle time going forward.
	world_timer = get_tree().get_first_node_in_group("world_timer")
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