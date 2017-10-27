#version 120

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;
uniform float frameTime;
uniform int worldTime;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;
varying vec3 normal;

const float lightRounding = 20.0;

#include "lib/colors.glsl"
#include "lib/time.glsl"

void main() 
{
    float skyLight = lmcoord.y * (1 - getTimeCycleMixer());
    float lum = mix(lmcoord.x, skyLight, skyLight);
    
    vec3 light_color = mix(light_destination, light_source, lum);
    
    vec4 light = vec4(mix(light_color / 2, light_sky, skyLight), 1);
    light = pow(light, vec4(1.7, 1.4, 1.2, 1));
    
    float normal_shading = dot(normal, vec3(0, 1, 0));
    vec4 final_color = light * texture2D(texture, texcoord) * color;
    
    final_color.rgb = final_color.rgb * (0.5 + (normal_shading + 1) / 2 * 0.5);
    
    /* DRAWBUFFERS:01 */
    gl_FragData[0] = final_color;
    gl_FragData[1] = vec4(lmcoord.x, lmcoord.y, 0, 1);
}