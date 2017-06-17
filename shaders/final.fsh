/**
 * Post processing
 * 
 * This shader is post-process the final picture. At the moment, all it's 
 * doing is pumping up green channel and adding a fog during rain which is 
 * fading to the sky color.
 */

#version 120

varying vec2 texcoord;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowProjectionInverse;

uniform vec3 upPosition;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2DShadow shadowtex0;

uniform float far;
uniform float rainStrength;
uniform int frameCounter;

#include "lib/converters.glsl"
#include "lib/colors.glsl"
#include "lib/sky.glsl"

const int shadowMapResolution = 2048;
const float shadowDistance = 128;

float getShadow(vec3 screenSpace)
{
    float shading = 1.0;
    
    vec4 pos = vec4(screenSpace, 1);
    
    pos = gbufferModelViewInverse * pos;
    pos = shadowModelView * pos;
    pos = shadowProjection * pos;
    
    pos.xyz = pos.xyz * 0.5 + 0.5;
    
    vec4 shadow = shadow2D(shadowtex0, pos.xyz);
    
    if (shadow.x < pos.z - 0.003)
    {
        shading = 0.5;
    }
    
    return shading;
}

void main()
{
    vec3 color = texture2D(colortex0, texcoord).rgb;
    float raw_depth = texture2D(depthtex0, texcoord).r;
    
    /* TODO: switch to toScreenSpace */
    float depth = pow(raw_depth, far * (far * 0.025)) * rainStrength;
    
    /* Fog during rain */
    if (depth != 1 || rainStrength == 1)
    {
        depth += sin(frameCounter * 0.05 + texcoord.x) * 0.05;
        depth = clamp(depth, 0, 1);
        
        vec3 skyColor = getSky(texcoord, raw_depth);
        float skyDot = 1 - getSkyDot(texcoord, raw_depth);
        
        gl_FragColor = vec4(mix(color, skyColor, depth), 1);
    }
    else
    {
        gl_FragColor = vec4(color, 1);
    }
    
    /* Applying shadwos */
    float shading = getShadow(toScreenSpace(texcoord, raw_depth));    
    
    if (raw_depth != 1)
    {
        if (shading != 1)
        {
            shading += (1 - shading) * rainStrength; 
        }
        
        gl_FragColor *= shading;
    }
    
    /* Increase dominance of the green channel */
    if (rainStrength > 0)
    {
        float factor = 1 + 0.05 * rainStrength;
        
        gl_FragColor.g *= factor;
        gl_FragColor /= factor;
    }
    
    gl_FragColor.a = 1;
}