shader_type canvas_item;

const vec2 shadow_scale = vec2(1.0, 4.0);
const vec2 shadow_offset = vec2(0.0);
uniform vec4 shadow_color : source_color;
const float shadow_skew = 4.0;
const float magic = 2.0;

void vertex() {
	float clamped_skew = shadow_skew / shadow_scale.y + 1.0;
	VERTEX.x *= clamped_skew;
	VERTEX.x += (clamped_skew - 1.0) / TEXTURE_PIXEL_SIZE.x * 0.5;
}

void fragment() {
	// Get size of texture in pixels
	float size_x = float(textureSize(TEXTURE, 0).x);
	float size_y = float(textureSize(TEXTURE, 0).y);
	
	// Create a new "UV" which remaps every UV value to a snapped pixel value
	vec2 UVr = vec2(floor(UV.x * magic * size_x)/(magic * size_x), floor(UV.y*size_y)/size_y);
	
	float clamped_skew = shadow_skew / shadow_scale.y + 1.0;
	vec2 expand_corrected_uv = vec2(UVr.x * clamped_skew, UVr.y);
	float skew = (expand_corrected_uv.y * shadow_skew) - shadow_skew;
	vec2 shadow_uv = vec2(0);
	shadow_uv.x = (expand_corrected_uv.x + skew) * shadow_scale.x + (1.0 - shadow_scale.x);
	shadow_uv.y = expand_corrected_uv.y * shadow_scale.y + (1.0 - shadow_scale.y);
	shadow_uv += shadow_offset;
	
	vec4 original_color = texture(TEXTURE, expand_corrected_uv);
	if (original_color.a > 0.0) {
		if (expand_corrected_uv.x > 1.0 || expand_corrected_uv.x < 0.0 || expand_corrected_uv.y > 1.0 || expand_corrected_uv.y < 0.0) {
			discard;
		}
		COLOR = original_color;
	} else {
		if (shadow_uv.x > 1.0 || shadow_uv.x < 0.0 || shadow_uv.y > 1.0 || shadow_uv.y < 0.0) {
			discard;
		}
		vec4 shadow_pixel = texture(TEXTURE, shadow_uv);
		COLOR = vec4(shadow_color.xyz, min(shadow_pixel.a, shadow_color.a));
	}
}
