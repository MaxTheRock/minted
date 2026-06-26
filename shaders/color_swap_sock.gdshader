shader_type canvas_item;
// used a tutorial here i can't lie.
uniform sampler2D palette_texture : filter_nearest;
uniform int color_count = 6;     // How many colors per palette (columns)
uniform int palette_count = 10;   // Total number of palettes (rows)
instance uniform int palette_index = 0;
uniform float tolerance = 0.1;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    vec4 final_color = current_color;

    // row index 0 contains the original reference colors.
    float original_y = 0.5 / float(palette_count);
    float target_y = (float(palette_index) + 0.5) / float(palette_count);

    for (int i = 0; i < color_count; i++) {
        float uv_x = (float(i) + 0.5) / float(color_count);
        
        // read original color from row 0.
        vec4 orig_color = texture(palette_texture, vec2(uv_x, original_y));

        if (distance(current_color.rgb, orig_color.rgb) < tolerance) {
            vec4 target_color = texture(palette_texture, vec2(uv_x, target_y));
            final_color.rgb = target_color.rgb;
            break;
        }
    }

    COLOR = vec4(final_color.rgb, current_color.a);
}
