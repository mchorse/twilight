#version 120

attribute vec4 mc_Entity;

uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform int frameCounter;

varying vec4 color;
varying vec2 lmcoord;
varying vec2 texcoord;

void main() 
{
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    
    if (mc_Entity.x == 8.0 || mc_Entity.x == 9.0)
    {
        vec4 position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
        vec3 worldpos = position.xyz + cameraPosition;
    
        gl_Position.y += sin(frameCounter / 40.0 + worldpos.x + worldpos.z * 4) * (0.15 * cos(frameCounter / 10.0 + worldpos.z));
    }
    
    color = gl_Color;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    texcoord = texcoord = gl_MultiTexCoord0.st;
}