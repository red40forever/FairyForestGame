shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform bool enabled = false;

void fragment() {
	if (enabled && COLOR.a == 0.0) {
		vec2 sample_positions[8] = {
			vec2(-TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y),
			vec2(0.0, -TEXTURE_PIXEL_SIZE.y),
			vec2(TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y),
			vec2(-TEXTURE_PIXEL_SIZE.x, 0.0),
			vec2(TEXTURE_PIXEL_SIZE.x, 0.0),
			vec2(-TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y),
			vec2(0.0, TEXTURE_PIXEL_SIZE.y),
			vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)
		};
		
		float alpha_sum = 0.0;
		for (int i = 0; i < sample_positions.length(); i++) {
			alpha_sum += texture(TEXTURE, UV + sample_positions[i]).a;
		}
		
		if (alpha_sum > 0.0) {
			COLOR = outline_color;
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
