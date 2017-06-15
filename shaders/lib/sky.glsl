/** 
 * Sky functions 
 * 
 * Requires colors.glsl and following uniforms:
 * - mat4 gbufferProjectionInverse
 * - vec4 upPosition
 */

float getSkyDot(vec2 coord)
{
    vec3 pos = normalize((gbufferProjectionInverse * vec4(coord * 2.0 - 1.0, 1.0, 1.0)).xyz);
    vec3 normUp = normalize(upPosition);
    
    return dot(pos, normUp);
}

vec3 getSky(vec2 coord)
{
    float skyPos = 1 - getSkyDot(coord);
    
    return mix(zenith_color, horizon_color, skyPos);
}