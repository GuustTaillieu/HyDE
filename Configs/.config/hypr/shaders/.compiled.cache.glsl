#version 300 es

// This is a template file for wallbash shaders this can be use for

#define wallbash_pry1 16,20,25 
#define wallbash_pry2 27,32,37
#define wallbash_pry3 71,81,95
#define wallbash_pry4 164,183,181

#define wallbash_txt1 255,255,255
#define wallbash_txt2 255,255,255
#define wallbash_txt3 255,255,255
#define wallbash_txt4 13,13,13

#define wallbash_1xa1 41,59,82
#define wallbash_1xa2 58,80,107
#define wallbash_1xa3 75,97,125
#define wallbash_1xa4 87,112,143
#define wallbash_1xa5 101,129,163
#define wallbash_1xa6 122,154,194
#define wallbash_1xa7 154,187,230
#define wallbash_1xa8 170,201,240
#define wallbash_1xa9 204,227,255

#define wallbash_2xa1 41,61,82
#define wallbash_2xa2 58,82,107
#define wallbash_2xa3 75,100,125
#define wallbash_2xa4 87,115,143
#define wallbash_2xa5 101,132,163
#define wallbash_2xa6 122,158,194
#define wallbash_2xa7 154,192,230
#define wallbash_2xa8 170,205,240
#define wallbash_2xa9 204,230,255

#define wallbash_3xa1 41,58,82
#define wallbash_3xa2 58,78,107
#define wallbash_3xa3 75,96,125
#define wallbash_3xa4 87,110,143
#define wallbash_3xa5 101,127,163
#define wallbash_3xa6 122,152,194
#define wallbash_3xa7 154,185,230
#define wallbash_3xa8 170,199,240
#define wallbash_3xa9 204,225,255

#define wallbash_4xa1 41,82,77
#define wallbash_4xa2 58,107,102
#define wallbash_4xa3 75,125,120
#define wallbash_4xa4 87,143,137
#define wallbash_4xa5 101,163,157
#define wallbash_4xa6 122,194,186
#define wallbash_4xa7 154,230,222
#define wallbash_4xa8 170,240,232
#define wallbash_4xa9 204,255,250


#define WALLBASH_COLOR wallbash_pry1
#define WALLBASH_TINT_OPACITY 0.2
#define WALLBASH_PRESERVE_BRIGHTNESS 0.8

// Wallbash Shader for Hyprland - Applies a color tint to background blur
//  by: khing

// Dev notes:
// This shader applies a color tint to Hyprland's background blur,
// allowing you to match the blur color with your system theme.
// It works well with transparency to create a consistent look across apps.

//!source=$XDG_CACHE_HOME/hyde/wallbash/colors.inc


/* 
To override this parameters create a file named './wallbash.inc'
We only need to match the file name and use 'inc' to incdicate that
 this is an "include" file
 Example: 

  ┌────────────────────────────────────────────────────────────────────────────┐
  │ //file ./wallbash.inc                                                      │
  │ // wallbash color to use                                                   │
  │ #define WALLBASH_COLOR wallbash_pry1                                       │
  └────────────────────────────────────────────────────────────────────────────┘
 */

precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

// Set RGB values as a vector (0-255 for each component)
// Example: vec3(255,100,50) for a reddish-orange color
// This is automatically divided by 255.0 to convert to 0.0-1.0 range

// Color as a string representation for easier editing
// FORMAT: "R,G,B" (values from 0-255)
#ifndef WALLBASH_COLOR
    #define WALLBASH_COLOR wallbash_pry1 // accepts r,g,b values
#endif

#ifndef WALLBASH_TINT_OPACITY
    #define WALLBASH_TINT_OPACITY 0.2 // Default fallback value
#endif
#ifndef WALLBASH_PRESERVE_BRIGHTNESS
    #define WALLBASH_PRESERVE_BRIGHTNESS 0.8 // Default fallback value
#endif

// Parse the color string into a vec3
// You cannot directly use the string, this is just for documentation
const vec3 COLOR = vec3(WALLBASH_COLOR) / 255.0;

// Set the opacity/strength of the tint (0.0 to 1.0)
// 0.0 = no tint, 1.0 = solid color
const float TINT_OPACITY = WALLBASH_TINT_OPACITY;  // Increased to make effect more visible

// Preserve brightness (0.0 to 1.0)
// Higher values maintain the original brightness of the background
// Lower values allow the tint color's brightness to have more effect
const float PRESERVE_BRIGHTNESS = WALLBASH_PRESERVE_BRIGHTNESS;


// Get luminance (brightness) value of a color
float getLuminance(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
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

