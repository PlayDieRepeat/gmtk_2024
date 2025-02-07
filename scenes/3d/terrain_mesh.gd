extends MeshInstance3D

@export var default_heightmap: Texture2D
var heightmap: Texture2D = null
var mat: Material = null
var smat: ShaderMaterial = null
var shader_mat_is_set := false
var height_offset := 0.0
var clicked_position := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(default_heightmap != null)
	heightmap = default_heightmap.duplicate()

	mat = get_active_material(0)
	if mat is ShaderMaterial:
		smat = mat as ShaderMaterial
		smat.set_shader_parameter('heightmap', heightmap)
		shader_mat_is_set = true
		
	create_convex_collision(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		var _eventMB = event as InputEventMouseButton
		if _eventMB.button_index == 1 and _eventMB.pressed == true:
			clicked_position = _eventMB.position
			print("Event mouse position: ", clicked_position)
			#turn screen coords into world coords
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("raise"):
		height_offset += 0.5
		if shader_mat_is_set:
			smat.set_shader_parameter('uHeight_offset', height_offset)
	if Input.is_action_just_pressed("lower"):
		height_offset -= 0.5
		if shader_mat_is_set:
			smat.set_shader_parameter('uHeight_offset', height_offset)
	
	if Input.is_action_just_pressed("click"):
		print("Fart!!!")

func raycast_from_mouse_position(p_mouse_position: Vector2) -> Node3D:
	return null
