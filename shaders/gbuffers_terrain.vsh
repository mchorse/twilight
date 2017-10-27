#version 120

varying vec4 color;
varying vec2 lmcoord;
varying vec2 texcoord;

uniform float frameTimeCounter; 

void main() 
{
    gl_Position = ftransform();
    
    color = gl_Color;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    texcoord = texcoord = gl_MultiTexCoord0.st;
}