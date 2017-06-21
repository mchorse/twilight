#version 120

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform float viewWidth;
uniform float viewHeight;
uniform int worldTime;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;

const float lightRounding = 20.0;

#include "lib/colors.glsl"

void main() 
{
    vec2 coord = floor(lmcoord * lightRounding + 0.5) / lightRounding;
    vec4 light = texture2D(lightmap, coord);
    
    float lum = 0.21 * light.r + 0.72 * light.g + 0.07 * light.b;
    
    light = vec4(mix(light_destination, light_source, pow(lum, 2.2)), 1);
    light = pow(light, vec4(1.7, 1.4, 1.2, 1));
    
    gl_FragColor = light * texture2D(texture, texcoord) * color;
}