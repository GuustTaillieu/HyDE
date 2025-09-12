#version 300 es

/*
┌─────────────────────────────────────────────────────────────────────────┐
│ This is a blank shader to disable hyprland shaders.                     │
└─────────────────────────────────────────────────────────────────────────┘
*/

precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main(){
  fragColor=texture(tex,v_texcoord);
}

void main() {
    // Get the original pixel color
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 originalColor = pixColor.rgb;
    
    // Get the tint color
    vec3 tintColor = COLOR;
    
    // Get luminance of the original color
    float originalLuminance = getLuminance(originalColor);
    
    // Create a luminance-preserving version of our tint
    // by combining the tint color with the original luminance
    vec3 luminancePreservedTint;
    if (PRESERVE_BRIGHTNESS > 0.0) {
        // Create a grayscale version with original brightness
        vec3 grayWithOriginalLuminance = vec3(originalLuminance);
        
        // Mix the tint color with grayscale that has original luminance
        luminancePreservedTint = mix(tintColor, grayWithOriginalLuminance, PRESERVE_BRIGHTNESS);
    } else {
        luminancePreservedTint = tintColor;
    }
    
    // Apply the tint based on the opacity setting
    vec3 result = mix(originalColor, luminancePreservedTint, TINT_OPACITY);
    
    // Final color with original alpha
    fragColor = vec4(result, pixColor.a);
}

