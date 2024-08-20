extends Resource
class_name RCameraConstants

@export var camera_x_step_size: int = 5
@export var camera_y_step_size: int = 5
@export var default_view_width: int = 640
@export var default_view_height: int = 360
@export var zoom_speed = Vector2(0.1,0.1)

func _init(p_camera_x_step_size: int = 0, p_camera_y_step_size: int = 0, p_default_view_width: int = 0, p_default_view_height: int = 0,p_zoom_speed = Vector2(0.0,0.0)):
	camera_x_step_size = p_camera_x_step_size
	camera_y_step_size = p_camera_y_step_size
	default_view_width = p_default_view_width
	default_view_height = p_default_view_height
	zoom_speed = p_zoom_speed
