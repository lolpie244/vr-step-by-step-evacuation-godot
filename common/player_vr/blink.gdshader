shader_type spatial;
render_mode blend_mix, cull_disabled;

uniform float blink_percentage : hint_range(0.0, 1.0) = 1.0;
uniform float feather : hint_range(0.0, 0.2) = 0.02;

void fragment() {
	ALBEDO = vec3(0.0);

    vec2 p = UV - vec2(0.5);
    p.y /= max(blink_percentage, 1e-4);

    float r = length(p);

    float edge0 = 0.5 + feather;
    float edge1 = 0.5 - feather;

    float mask = 1.0 - smoothstep(edge1, edge0, r);

    // now invert: discard if mask > 0 (inside)
    if (blink_percentage > 1e-3 && mask > 0.0) discard;
}
