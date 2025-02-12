extends Node3D

@export var default_heightmap: Texture2D

@onready var terrain_mesh : MeshInstance3D = %TerrainMesh
var heightmap: Texture2D = null
var shader_mat: ShaderMaterial = null
var shader_mat_is_set := false
var height_offset_vertex_scalar := 0.0
var static_body : StaticBody3D = null

var capture_mouse := true

func _ready() -> void:
	assert(terrain_mesh != null)
	assert(default_heightmap != null)
	var _mesh : Mesh = terrain_mesh.mesh
	heightmap = default_heightmap.duplicate()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var _mat : Material = terrain_mesh.get_active_material(0)
	if _mat is ShaderMaterial:
		shader_mat = _mat as ShaderMaterial
		shader_mat.set_shader_parameter('heightmap', heightmap)
		shader_mat_is_set = true
		
	terrain_mesh.create_convex_collision(true)
	var temp_node = terrain_mesh.get_child(0)
	if temp_node != null:
		if temp_node is StaticBody3D:
			static_body = temp_node as StaticBody3D
			static_body.collision_mask = 2
			static_body.input_event.connect(on_input_event)
			print("Static body signal hooked up.")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("build"):
		capture_mouse = !capture_mouse
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if capture_mouse else Input.MOUSE_MODE_VISIBLE

	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("raise"):
		height_offset_vertex_scalar += 0.5
		if shader_mat_is_set:
			shader_mat.set_shader_parameter('uHeight_offset', height_offset_vertex_scalar)
	if Input.is_action_just_pressed("lower"):
		height_offset_vertex_scalar -= 0.5
		if shader_mat_is_set:
			shader_mat.set_shader_parameter('uHeight_offset', height_offset_vertex_scalar)

func on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("I am clicked on at: ", event_position)
