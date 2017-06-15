#version 120

varying vec2 texcoord;

uniform mat4 gbufferProjectionInverse;

uniform vec3 upPosition;

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float far;
uniform float rainStrength;
uniform int frameCounter;

#include "lib/colors.glsl"
#include "lib/sky.glsl"

void main()
{
    vec3 color = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;
    
    depth = pow(depth, far * (far * 0.025)) * rainStrength;
    
    if (depth != 1 || rainStrength == 1)
    {
        depth += sin(frameCounter * 0.05 + texcoord.x) * 0.05;
        depth = clamp(depth, 0, 1);
        
        vec3 skyColor = getSky(texcoord);
        float skyDot = 1 - getSkyDot(texcoord);
        
        if (skyDot < 0)
        {
            depth = mix(0, depth, 1 + skyDot);
        }
        
        gl_FragColor = vec4(mix(color, skyColor, depth), 1);
    }
    else
    {
        gl_FragColor = vec4(color, 1);
    }
    
    gl_FragColor.g *= 1.1;
    gl_FragColor /= 1.1;
    gl_FragColor.a = 1;
}