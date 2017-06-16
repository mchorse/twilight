/**
 * Jodie's converter toScreenSpace functions. Requires two uniforms:
 * - mat4 gbufferProjectionInverse
 * - samper2D depthtex0
 * 
 * @author Jodie
 */

vec4 iProjDiag = vec4(gbufferProjectionInverse[0].x, gbufferProjectionInverse[1].y, gbufferProjectionInverse[2].zw);

vec3 toScreenSpace(vec2 p, float d) 
{
    vec3 p3 = vec3(p, d) * 2.0 - 1.0;
    vec4 fragposition = iProjDiag * p3.xyzz + gbufferProjectionInverse[3];

    return fragposition.xyz / fragposition.w;
}