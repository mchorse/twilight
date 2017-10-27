/**
 * Post processing
 * 
 * This shader is post-process the final picture. At the moment, it's 
 * responsible for:
 * 
 * - pumping up blue channel during the rain
 * - adding the fog during rain 
 * - simple DoF
 * - vignette
 */

#version 120
#extension GL_EXT_gpu_shader4 : enable

#define DOF
#define SHADOWS

varying vec2 texcoord;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowProjectionInverse;

uniform vec3 upPosition;
uniform ivec2 eyeBrightnessSmooth;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform sampler2DShadow shadowtex0;

uniform float far;
uniform float rainStrength;
uniform float frameTime;
uniform float centerDepthSmooth;
uniform int frameCounter;
uniform int worldTime;

uniform float viewWidth;
uniform float viewHeight;

#include "lib/converters.glsl"
#include "lib/colors.glsl"
#include "lib/time.glsl"
#include "lib/sky.glsl"
#include "lib/shadows.glsl"

const float eyeBrightnessHalflife = 2.0;
const float centerDepthHalflife = 2.0f;

vec4 blur(sampler2D tex, vec2 newcoord, float radius) 
{
    vec2 pixel = vec2(1 / viewWidth, 1 / viewHeight) * radius;

    vec3 blur0 = texture2D(tex,(newcoord)).rgb;
    vec3 blur1 = texture2D(tex,(newcoord + pixel * vec2(0, 1))).rgb;
    vec3 blur2 = texture2D(tex,(newcoord + pixel * vec2(1, 0))).rgb;
    vec3 blur3 = texture2D(tex,(newcoord - pixel * vec2(0, 1))).rgb;
    vec3 blur4 = texture2D(tex,(newcoord - pixel * vec2(1, 0))).rgb;

    return vec4((blur0 + blur1 + blur2 + blur3 + blur4) / 5, 1.0);
}

void main()
{
    vec3 color = texture2D(colortex0, texcoord).rgb;
    vec2 luma = texture2D(colortex1, texcoord).rg;
    float raw_depth = texture2D(depthtex0, texcoord).r;
    
    color = rgb2hsv(color);
    color.g *= 1.25;
    color.b *= 1.25;
    color = hsv2rgb(color);
    
    /* Depth of Field */
    #ifdef DOF
        float blur_factor = abs(pow(centerDepthSmooth, 50) - pow(raw_depth, 50));

        blur_factor = clamp(pow(1 - blur_factor, 3), 0, 1);

        if (blur_factor < 1)
        {
            color = mix(blur(colortex0, texcoord, (1 - blur_factor) * 3.5).rgb, color, blur_factor);
        }
    #endif
    
    /* Fog during rain */
    
    /* TODO: switch to toScreenSpace */
    float depth = pow(raw_depth, far * (far * 0.025)) * rainStrength;
    
    if (depth != 1 || rainStrength == 1)
    {
        vec3 skyColor = getSky(texcoord, raw_depth);
        float skyDot = 1 - getSkyDot(texcoord, raw_depth);
        float fog = depth;
        
        fog = clamp(fog, 0, 1);
        
        /* Hiding fog in the dungeon */
        fog *= 1 - (1 - luma.y) * (1 - eyeBrightnessSmooth.y / 240.0);
        
        gl_FragColor = vec4(mix(color, skyColor, fog), 1);
    }
    else
    {
        gl_FragColor = vec4(color, 1);
    }
    
    #ifdef SHADOWS
        if (raw_depth != 1)
        {
            gl_FragColor *= getShadow(toScreenSpace(texcoord, raw_depth), 0.5);
        }
    #endif
    
    /* Vignette */
    gl_FragColor *= 1.0 - pow(length(texcoord.xy - 0.5), 3);
    gl_FragColor.a = 1;
}