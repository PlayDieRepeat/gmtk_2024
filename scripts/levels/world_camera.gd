class_name WorldCamera
extends Camera2D

@export var camera_constant: RCameraConstants
var scroll_step_size := Vector2i (0,0)
var zoomed_viewport_size := Vector2 (0.0, 0.0)

func zoom_in_and_out(p_zoom_speed = Vector2(0, 0)) -> void:
	if (p_zoom_speed.y < 0 and zoomed_viewport_size.y + p_zoom_speed.y < camera_constant.default_view_height + p_zoom_speed.y) or (p_zoom_speed.x > 0):
		zoom += p_zoom_speed
		position = lerp(position, get_local_mouse_position(), 0.05)

func scrolling() -> void:
	zoomed_viewport_size = Vector2(get_viewport_rect().size.x / zoom.x, get_viewport_rect().size.y / zoom.y) 
	var threshold := Vector2 (zoomed_viewport_size.x / 15, zoomed_viewport_size.y / 10)
	
	if get_local_mouse_position().x < threshold.x and position.x > -camera_constant.default_view_width:
		scroll_step_size.x = -clamp((threshold.x - get_local_mouse_position().x) / 10, 1, camera_constant.camera_x_step_size)
		position.x += scroll_step_size.x
	elif get_local_mouse_position().x > zoomed_viewport_size.x - threshold.x and position.x < camera_constant.default_view_width:
		scroll_step_size.x = clamp((get_local_mouse_position().x - (zoomed_viewport_size.x - threshold.x)) / 10, 1, camera_constant.camera_x_step_size)
		position.x += scroll_step_size.x
	
	if get_local_mouse_position().y > zoomed_viewport_size.y - threshold.y and position.y < camera_constant.default_view_height - zoomed_viewport_size.y:
		scroll_step_size.y = clamp((get_local_mouse_position().y - (zoomed_viewport_size.y - threshold.y)) / 10, 1, camera_constant.camera_y_step_size)
		position.y += scroll_step_size.y
	elif get_local_mouse_position().y < threshold.y and position.y > 0:
		scroll_step_size.y = -clamp((threshold.y - get_local_mouse_position().y) / 10, 1, camera_constant.camera_y_step_size)
		position.y += scroll_step_size.y
	
	if position.y > camera_constant.default_view_height - zoomed_viewport_size.y:
		position.y = camera_constant.default_view_height - zoomed_viewport_size.y
	elif threshold.y and position.y < 0:
		position.y = 0

func _ready() -> void:
	zoomed_viewport_size = Vector2 (get_viewport_rect().size.y / zoom.y, get_viewport_rect().size.x / zoom.x)

func _process(_delta: float = 0.0) -> void:
	if get_local_mouse_position() < get_viewport_rect().size and get_local_mouse_position() > Vector2(0,0):
		scrolling()
		if Input.is_action_just_released("Scroll Up"):
			zoom_in_and_out(camera_constant.zoom_speed)
		elif Input.is_action_just_released("Scroll Down"):
			zoom_in_and_out(-camera_constant.zoom_speed)
