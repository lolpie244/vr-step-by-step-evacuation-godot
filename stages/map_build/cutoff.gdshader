shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;


uniform sampler2D sprite_texture : source_color, filter_nearest;

uniform vec2 plane_pos;
uniform vec2 plane_size;
uniform vec4 border_color: source_color;

varying vec2 wvtx;

void vertex() {
	// Called for every vertex the material is visible on.
	wvtx = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xy;
}

void fragment() {
	vec2 vertexDistance = abs(plane_pos - wvtx);
	if (vertexDistance.x > plane_size.x || vertexDistance.y > plane_size.y) discard;

    vec2 plane_size_ext = plane_size * 1.2;

	float dist_to_edge = min(
	    plane_size_ext.x - vertexDistance.x,
	    plane_size_ext.y - vertexDistance.y
	);

	float border_dist = smoothstep(0.0, 0.12, dist_to_edge);
	EMISSION = (mix(border_color * 7.0, vec4(0.0), border_dist)).rgb;

	vec4 color = texture(sprite_texture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
