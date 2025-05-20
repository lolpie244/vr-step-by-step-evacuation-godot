shader_type spatial;

uniform vec2 plane_pos;
uniform vec2 plane_size;

varying vec2 wvtx;

void vertex() {
	// Called for every vertex the material is visible on.
	wvtx = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
}

void fragment() {
	vec2 vertexDistance = abs(plane_pos - wvtx);
	if (vertexDistance.x > plane_size.x || vertexDistance.y > plane_size.y) discard;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
