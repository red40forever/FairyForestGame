shader_type canvas_item;

uniform vec4 shadow_color : source_color;
uniform vec2 shadow_scale;
uniform vec2 shadow_skew;
uniform vec2 skew_offset;

void vertex() {
	VERTEX *= shadow_scale;
	VERTEX = VERTEX + shadow_skew * VERTEX.yx + skew_offset;
}

void fragment() {
	COLOR = vec4(shadow_color.rgb, min(COLOR.a, shadow_color.a));
}