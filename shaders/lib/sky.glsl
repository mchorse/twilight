/** 
 * Sky functions 
 * 
 * Requires colors.glsl and following uniforms:
 * - mat4 gbufferProjectionInverse
 * - vec4 upPosition
 *
 * @requires "converers.glsl"
 */

float getSkyDot(vec2 coord, float depth)
{
    vec3 pos = normalize(toScreenSpace(coord, depth));
    vec3 normUp = normalize(upPosition);
    
    return dot(pos, normUp);
}

vec3 getSky(vec2 coord, float depth)
{
    float skyPos = 1 - getSkyDot(coord, depth);
    
    return mix(zenith_color, horizon_color, skyPos);
}