shader_type spatial;

uniform sampler2D _albedo : source_color, filter_nearest;

void vertex() {
	//do_what_you_want();
}

void fragment() {
	vec4 color = texture(_albedo, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}