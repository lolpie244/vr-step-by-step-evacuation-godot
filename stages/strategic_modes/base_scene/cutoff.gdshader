shader_type spatial;

// standard material
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

//

uniform vec2 plane_pos;
uniform vec2 plane_size;
uniform vec4 border_color: source_color;

varying vec2 wvtx;

void vertex() {
	// Called for every vertex the material is visible on.
	wvtx = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
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

	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
