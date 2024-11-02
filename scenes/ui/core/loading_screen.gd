extends CanvasLayer
class_name LoadingScreen

signal loading_screen_has_full_coverage
signal loading_outro_finished

@export var show_progress_bar := false

@onready var animation_player: AnimationPlayer= $AnimationPlayer
@onready var progress_bar: ProgressBar= $LoadingUI/Center/VBoxContainer/ProgressBar

func _ready() -> void:
	if show_progress_bar == false:
		if progress_bar != null:
			progress_bar.visible = false
	else:
		if progress_bar != null:
			progress_bar.visible = true

func _update_progress_bar(new_value: float) -> void:
	progress_bar.set_value_no_signal(new_value * 100)

func _start_outro_animation() -> void:
	#await Signal(animation_player, "animation_finished") #  is this a bug?
	animation_player.play("end_load")
	await Signal(animation_player, "animation_finished")
	loading_outro_finished.emit()
