extends Camera2D

@export var camera_constant: RCameraConstants
var x_scroll_step_size: int = 0
var y_scroll_step_size: int = 0
var viewport_height: float = 0.0
var viewport_width: float = 0.0

func zoom_in_and_out(p_zoom_speed = Vector2(0, 0)) -> void:
	if (p_zoom_speed.y < 0 and viewport_height + p_zoom_speed.y < camera_constant.default_view_height + p_zoom_speed.y) or (p_zoom_speed.x > 0):
		zoom += p_zoom_speed
		position = lerp(position, get_local_mouse_position(), 0.05)

func scrolling() -> void:
	viewport_width = get_viewport_rect().size.x / zoom.x
	viewport_height = get_viewport_rect().size.y / zoom.y
	var threshold_x = viewport_width / 15
	var threshold_y = viewport_height / 10
	var local_mouse_pos_x = get_local_mouse_position().x
	var local_mouse_pos_y = get_local_mouse_position().y
	
	if local_mouse_pos_x < threshold_x and position.x > -camera_constant.default_view_width:
		x_scroll_step_size = -clamp((threshold_x - local_mouse_pos_x) / 10, 1, camera_constant.camera_x_step_size)
		position.x += x_scroll_step_size
	elif local_mouse_pos_x > viewport_width - threshold_x and position.x < camera_constant.default_view_width:
		x_scroll_step_size = clamp((local_mouse_pos_x - (viewport_width - threshold_x)) / 10, 1, camera_constant.camera_x_step_size)
		position.x += x_scroll_step_size
	
	if local_mouse_pos_y > viewport_height - threshold_y and position.y < camera_constant.default_view_height - viewport_height:
		y_scroll_step_size = clamp((local_mouse_pos_y - (viewport_height - threshold_y)) / 10, 1, camera_constant.camera_y_step_size)
		position.y += y_scroll_step_size
	elif local_mouse_pos_y < threshold_y and position.y > 0:
		y_scroll_step_size = -clamp((threshold_y - local_mouse_pos_y) / 10, 1, camera_constant.camera_y_step_size)
		position.y += y_scroll_step_size
	
	if position.y > camera_constant.default_view_height - viewport_height:
		position.y = camera_constant.default_view_height - viewport_height
	elif threshold_y and position.y < 0:
		position.y = 0

func _ready() -> void:
	viewport_height = get_viewport_rect().size.y / zoom.y
	viewport_width = get_viewport_rect().size.x / zoom.x

func _process(_delta: float = 0.0) -> void:
	scrolling()
	if Input.is_action_just_released("Scroll Up"):
		zoom_in_and_out(camera_constant.zoom_speed)
	elif Input.is_action_just_released("Scroll Down"):
		zoom_in_and_out(-camera_constant.zoom_speed)
