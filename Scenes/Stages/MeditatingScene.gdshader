shader_type canvas_item;

// Textures
uniform sampler2D texture_albedo;        // Your "carine" texture
uniform sampler2D texture_displacement; // Your displacement map

// Control offset
uniform float displacement_strength = 0.1;
uniform vec2 uv_offset = vec2(0.0, 0.0);

void fragment() {
    // Sample displacement map
    vec2 displaced_uv = UV + uv_offset;  // Add offset
    float displacement = texture(texture_displacement, displaced_uv).r; // Get displacement value

    // Apply displacement to UVs
    displaced_uv += normalize(UV - 0.5) * displacement * displacement_strength;

    // Sample the albedo texture with displaced UVs
    COLOR = texture(texture_albedo, displaced_uv);
}
