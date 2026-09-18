shader_type canvas_item;

uniform float screen_height = 360.0;
uniform float strength = 5.0;

void fragment() {
    int pixel_y = int(UV.x * screen_height);
    
    float diff_y = 0.0;
    
    // Check alternating pixel rows correctly
    if (pixel_y % 2 == 1) {
        diff_y = 0.035 * sin((strength * UV.y) + (1.0 * TIME));
    } else {
        diff_y = 0.035 * sin((strength * UV.y + PI) + (1.0 * TIME));
    }
    
    vec4 tex_color = texture(TEXTURE, vec2(UV.x, UV.y + diff_y));
    

    tex_color = mix(tex_color, vec4(0.0, 0.0, 0.0, tex_color.a), 0.5);

    
    COLOR = tex_color;
    COLOR.a *= 0.5;
}