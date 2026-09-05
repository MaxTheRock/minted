shader_type canvas_item;

uniform float SPEED = 1.0;
uniform float INTENSITY = 0.03; 
uniform float BAND_PIXEL_HEIGHT = 1.0;
uniform float SCANLINE_SPEED = 20.0;

uniform float DARKEN_FACTOR : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	float pixel_y = UV.y / TEXTURE_PIXEL_SIZE.y;
	
	float diff_x = 0.0;
	
	if (mod(pixel_y, BAND_PIXEL_HEIGHT * 2.0) < BAND_PIXEL_HEIGHT) {
		diff_x = 0.1 * tan((INTENSITY * pixel_y) + (SPEED * TIME));
	} else {
		diff_x = 0.1 * tan((INTENSITY * pixel_y) + (SPEED * TIME));
	}
	
	vec4 tex_color = texture(TEXTURE, vec2(UV.x + diff_x, UV.y));
	
	tex_color.rgb *= DARKEN_FACTOR;
	
	float scanline_alpha = clamp(sin((UV.x * 480.0 * PI)) / 1.0, 0.0, 1.0);
	
	vec4 black_overlay = vec4(0.0, 0.0, 0.0, tex_color.a);
	COLOR = mix(tex_color, black_overlay, scanline_alpha);
}