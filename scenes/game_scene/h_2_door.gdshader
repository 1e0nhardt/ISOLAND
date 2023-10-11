shader_type canvas_item;

uniform float percent: hint_range(0.0, 1.2, 0.01);

void fragment() {
    float border = step(percent, UV.x);
    vec4 texture_color = texture(TEXTURE, UV);
    if (texture_color.a >= 0.1) {
        texture_color.a = border;
    }
	COLOR = texture_color;
}
