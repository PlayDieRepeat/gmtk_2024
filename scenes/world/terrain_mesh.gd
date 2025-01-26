extends MeshInstance3D

@export var default_heightmap: Texture2D
var heightmap: Texture2D = null
var mat: Material = null
var smat: ShaderMaterial = null
var shader_mat_is_set := false
var height_offset := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(default_heightmap != null)
	heightmap = default_heightmap.duplicate()

	mat = get_active_material(0)
	if mat is ShaderMaterial:
		smat = mat as ShaderMaterial
		smat.set_shader_parameter('heightmap', heightmap)
		shader_mat_is_set = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		height_offset += 0.5
		if shader_mat_is_set:
			smat.set_shader_parameter('uHeight_offset', height_offset)
	if Input.is_action_just_pressed("down"):
		height_offset -= 0.5
		if shader_mat_is_set:
			smat.set_shader_parameter('uHeight_offset', height_offset)	
		# move all points of the image up
		#heightmap.get_image().flip_x()
		#heightmap.get_image().flip_y()
