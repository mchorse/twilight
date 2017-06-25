/**
 * Shadows. Requires following uniforms:
 * - mat4 gbufferModelViewInverse;
 * - mat4 shadowModelView;
 * - mat4 shadowProjection;
 * - sampler2DShadow shadowtex0;
 */

const int shadowMapResolution = 2048;
const float shadowDistance = 128;

float getShadow(vec3 screenSpace)
{
    float shading = 1.0;
    
    vec4 pos = vec4(screenSpace, 1);
    
    pos = gbufferModelViewInverse * pos;
    pos = shadowModelView * pos;
    pos = shadowProjection * pos;
    
    pos.xyz = pos.xyz * 0.5 + 0.5;
    
    vec4 shadow = shadow2D(shadowtex0, pos.xyz);
    
    if (shadow.x < pos.z - 0.003)
    {
        shading = 0.5;
    }
    
    return shading;
}