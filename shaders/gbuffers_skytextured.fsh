/**
 * Sky textured shader
 * 
 * Exists solely as placeholder (so gbuffers_basic won't be used for this one).
 */

#version 120

varying vec2 texcoord;

uniform sampler2D texture;

void main() 
{
    /* DRAWBUFFERS:01 */
	gl_FragData[0] = texture2D(texture, texcoord);
}
