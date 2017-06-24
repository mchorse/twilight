#version 120

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;
uniform float frameTime;
uniform int worldTime;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;

const float lightRounding = 20.0;

#include "lib/colors.glsl"
#include "lib/time.glsl"

void main() 
{
    float skyLight = lmcoord.y * (1 - getTimeCycleMixer());
    float lum = mix(lmcoord.x, skyLight, skyLight);
    
    lum = floor(lum * lightRounding) / lightRounding;
    
    vec3 light_color = mix(light_destination, light_source, lum);
    
    vec4 light = vec4(mix(light_color, light_sky, skyLight), 1);
    light = pow(light, vec4(1.7, 1.4, 0.5, 1));
    
    /* Applying lightmap on the texture and color */
    
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = light * texture2D(texture, texcoord) * vec4(0, 1, 0.5, 1);
}