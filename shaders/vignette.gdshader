shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 rect_size = vec2(1920.0, 1080.0);
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
	vec2 point = (UV - center) * rect_size;
	float max_d = length(max(center, 1.0 - center) * rect_size);
	float d = length(point) / max_d;

	float r = mix(1.0, 0.0, progress);
	float a = step(r, d);

	COLOR = vec4(color.rgb, a * color.a);
}