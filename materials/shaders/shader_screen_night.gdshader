shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 night_tint : source_color;
uniform float night_tint_amount : hint_range(0.0, 1.0);

void fragment() {
        vec4 color = texture(screen_texture, UV);
		
		color.rgb *= mix(vec3(1.0), night_tint.rgb, night_tint_amount);
		
		COLOR = color;
}