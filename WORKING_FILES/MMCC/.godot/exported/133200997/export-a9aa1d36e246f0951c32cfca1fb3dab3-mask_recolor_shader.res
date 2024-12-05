RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script        '   res://Shaders/mask_recolor_shader.tres �          Shader          �  shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec4 recolor : source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform bool use_mask = true;
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask_texture, UV);
    
    vec4 final_color = original_color;
    
    // Apply masking if enabled
    if (use_mask) {
        final_color.a *= mask_color.a;
    }
    
    // Apply recoloring
    final_color.rgb = mix(final_color.rgb, recolor.rgb, recolor.a);
    
    // Apply flash
    final_color.rgb = mix(final_color.rgb, vec3(1.0, 1.0, 1.0), flash_amount);
    
    COLOR = final_color;
}       RSRC