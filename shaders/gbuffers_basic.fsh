#version 120

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform float viewWidth;
uniform float viewHeight;

varying vec4 color;
varying vec2 texcoord;
varying vec2 lmcoord;

const float lightRounding = 20.0;

void main() 
{
    vec2 coord = floor(lmcoord * lightRounding + 0.5) / lightRounding;
    vec4 light = texture2D(lightmap, coord);
    
    gl_FragColor = light * texture2D(texture, texcoord) * color;
    
    // /* DRAWBUFFERS:7 */
    // gl_FragData[0]
}