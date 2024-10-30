shader_type canvas_item;
render_mode unshaded;

uniform int pixel_size;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xyz;
}

void fragment() {
	float corrected_pixe_size = float(pixel_size) + mod(float(pixel_size), 2.0);
	vec2 enlarged_pixel_size = SCREEN_PIXEL_SIZE * corrected_pixe_size;
	vec2 uv = floor(SCREEN_UV / enlarged_pixel_size) * enlarged_pixel_size;
	COLOR = texture(screen_texture, uv);
}