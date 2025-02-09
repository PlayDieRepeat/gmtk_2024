extends Node3D

@export var default_heightmap: Texture2D

@onready var terrain_mesh : MeshInstance3D = %TerrainMesh
var heightmap: Texture2D = null
var shader_mat: ShaderMaterial = null
var shader_mat_is_set := false
var height_offset_vertex_scalar := 0.0

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
