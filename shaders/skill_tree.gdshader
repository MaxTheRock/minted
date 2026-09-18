shader_type canvas_item;

uniform float screen_height = 270.0;

void fragment() {
    // Convert normalized UV.y (0.0 to 1.0) into integer pixel coordinates
    int pixel_y = int(UV.y * screen_height);
    
    float diff_x = 0.0;
    
    // Check alternating pixel rows
    if (pixel_y % 2 == 1) {
        diff_x = 0.035 * sin((10.0 * UV.y) + (2.0 * TIME));
    } else {
        diff_x = 0.035 * sin((10.0 * UV.y + PI) + (2.0 * TIME));
    }
    
    // Sample texture with wave offset
    vec4 tex_color = texture(TEXTURE, vec2(UV.x + diff_x, UV.y));
    

    tex_color = mix(tex_color, vec4(0.0, 0.0, 0.0, tex_color.a), 0.5);

    

    COLOR = tex_color;
    COLOR.a *= 0.5;
}