#version 120

uniform mat4 gbufferProjectionInverse;

uniform vec3 upPosition;

uniform float viewWidth;
uniform float viewHeight;

#include "lib/colors.glsl"
#include "lib/sky.glsl"

void main() 
{
    /* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(getSky(gl_FragCoord.xy / vec2(viewWidth, viewHeight)), 1);
}