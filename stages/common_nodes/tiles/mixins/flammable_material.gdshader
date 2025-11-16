shader_type spatial;
uniform float durability : hint_range(0.0, 1.0) = 1;

void fragment() {
	ALBEDO = vec3(0, 0, 0);
	ALPHA = 1.0 - durability;
}

