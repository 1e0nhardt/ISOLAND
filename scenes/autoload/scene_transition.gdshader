shader_type canvas_item;

uniform float percent: hint_range(0.0, 1.0, 0.01);
uniform float screen_uv_scale: hint_range(0.5, 1.0, 0.01) = 1.;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec2 uv = SCREEN_UV * screen_uv_scale - vec2(screen_uv_scale / 2.);
	vec4 screen_color = textureLod(screen_texture, uv + vec2(.5), 0.0);

    vec3 color = mix(screen_color.rgb, vec3(0., 0., 0.), percent);
    COLOR = vec4(color, 1.);
//    COLOR = vec4(vec3(step(.9, uv.x), .0, 0.), 1.);
}
