#version 120

uniform int frameCounter;

varying vec4 color;
varying vec2 lmcoord;
varying vec2 texcoord;

void main() 
{
	gl_Position = ftransform();
    gl_Position.y += sin(frameCounter / 30.0 + gl_Position.x + gl_Position.z * 4) * (0.15 * cos(frameCounter / 10.0 + gl_Position.z));
    
    color = gl_Color;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    texcoord = texcoord = gl_MultiTexCoord0.st;
}