#version 120

varying vec2 texcoord;

uniform sampler2D texture;

void main() 
{
    /* DRAWBUFFERS:01 */
	gl_FragData[0] = texture2D(texture, texcoord);
}
