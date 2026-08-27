shader_type canvas_item;

uniform sampler2D noise : repeat_enable, filter_nearest;
uniform sampler2D icon : repeat_enable, filter_nearest;

uniform float speed : hint_range(0.0, 5.0) = 1.0;
uniform float distortion : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Sample noise
    float n = texture(noise, UV * 2.0 + TIME * speed * 0.1).r;

    // Turn the noise value into an angle
    float angle = n * 6.283185;

    // Random direction based on the noise
    vec2 direction = vec2(cos(angle), sin(angle));

    // Move the UV in that direction
    vec2 offset = direction * speed * TIME * distortion;

    COLOR = texture(icon, UV + offset);
}