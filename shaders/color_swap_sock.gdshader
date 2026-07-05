shader_type canvas_item;

uniform vec2 shadow_offset = vec2(4.0, 4.0);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
    // Get the base texture pixel
    vec4 col = texture(TEXTURE, UV);

    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 offset_uv = UV - (shadow_offset / size);
    vec4 shadow_col = texture(TEXTURE, offset_uv);

    COLOR = mix(vec4(shadow_color.rgb, shadow_col.a * shadow_color.a), col, col.a);
}
