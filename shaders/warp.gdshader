shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.4;
uniform float speed : hint_range(0.0, 2.0) = 0.08;

void fragment() {
    float t = TIME * speed;

    // Pixelate the effect
    vec2 pixel_size = vec2(810.0, 445.5);
    vec2 uv = floor(SCREEN_UV * pixel_size) / pixel_size;

    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 pos = uv * 2.0 - 1.0;

    pos.y *= res.y / res.x;
    pos *= 4.0;

    for (float k = 1.0; k < 7.0; k += 1.0) {
        pos.x += strength * sin(2.0 * t + k * 1.5 * pos.y) + t * 0.5;
        pos.y += strength * cos(2.0 * t + k * 1.5 * pos.x);
    }

    // Black → red
    float pattern = 0.5 + 0.5 * sin(pos.x + pos.y + t);

    vec3 red = vec3(1.0, 0.45, 0.45);
    vec3 col = mix(vec3(0.0), red, pattern);

    COLOR = vec4(col, 1.0);
}