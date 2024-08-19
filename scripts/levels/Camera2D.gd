extends Camera2D

var step = 5
var maxStep = 5
var zoomSpeed = Vector2(0.1,0.1)
var viewportSizeY: float = get_viewport_rect().size.y/zoom.y

func zoomInAndOut(zoomAmount):
	var maxZoomOut = 360
	if (zoomAmount.y < 0 and maxZoomOut > viewportSizeY + zoomSpeed.y) or (zoomAmount.x > 0):
		zoom += zoomAmount
		position = lerp(position, get_local_mouse_position(), 0.05)
	
func scrolling(isHorizontal, isVertical):
	if (isHorizontal):
		var viewportSizeX = get_viewport_rect().size.x/zoom.x
		var thresholdX = viewportSizeX/15
		var localMousePosX = get_local_mouse_position().x
		if localMousePosX < thresholdX and position.x > -640:
			step = clamp((thresholdX-localMousePosX)/10,1,5)
			position.x -= step
		elif localMousePosX > viewportSizeX - thresholdX and position.x < 640:
			step = clamp((localMousePosX-(viewportSizeX - thresholdX))/10,1,5)
			position.x += step
			
	if (isVertical):
		var localMousePosY = get_local_mouse_position().y
		var thresholdY = viewportSizeY/10
		viewportSizeY = get_viewport_rect().size.y/zoom.y
		if localMousePosY > viewportSizeY - thresholdY and position.y < 360-viewportSizeY:
			step = clamp((localMousePosY-(viewportSizeY-thresholdY))/10,1,5)
			position.y += step
		elif position.y > 360-viewportSizeY:
			position.y = 360-viewportSizeY
			
		if localMousePosY < thresholdY and position.y > 0:
			step = clamp((thresholdY-localMousePosY)/10,1,5)
			position.y -= step
		elif thresholdY and position.y < 0:
			position.y = 0
			
func _ready() -> void:
	viewportSizeY = get_viewport_rect().size.y/zoom.y

func _process(_delta):
	scrolling(true, true)
	if Input.is_action_just_released("Scroll Up"):
		zoomInAndOut(zoomSpeed)
	elif Input.is_action_just_released("Scroll Down"):
		zoomInAndOut(-zoomSpeed)
