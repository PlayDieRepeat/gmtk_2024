shader_type spatial;

render_mode wireframe, unshaded, cull_disabled;

uniform sampler2D heightmap;

uniform sampler2D ground;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += texture(heightmap, UV).r;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
