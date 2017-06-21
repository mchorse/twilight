/** 
 * Sky functions 
 * 
 * Requires colors.glsl and following uniforms:
 * - mat4 gbufferProjectionInverse
 * - vec4 upPosition
 * - int worldTime
 * - float frameTime
 *
 * @requires "converers.glsl"
 */

/**
 * How fast night fades to day, and vice versa in ticks
 */
const int skyFadePeriod = 20;

float getSkyDot(vec2 coord, float depth)
{
    vec3 pos = normalize(toScreenSpace(coord, depth));
    vec3 normUp = normalize(upPosition);
    
    return dot(pos, normUp);
}

vec3 getSkyColor(vec2 coord, float depth, vec3 zenithRGB, vec3 horizonRGB, vec3 voidRGB)
{
    float dot = getSkyDot(coord, depth);
    float skyPos = 1 - dot;
    
    if (dot >= 0)
    {
        return mix(horizonRGB, zenithRGB, pow(dot, 2));
    }
    else
    {
        return mix(horizonRGB, voidRGB, clamp(-dot, 0, 1));
    }
}

vec3 getSky(vec2 coord, float depth)
{
    vec3 day = getSkyColor(coord, depth, zenith_color, horizon_color, void_color);
    vec3 night = getSkyColor(coord, depth, night_zenith_color, night_horizon_color, night_void_color);
    
    float time = float(worldTime) + frameTime;
    float cycleTime = mod(time, 12000.0);
    
    float mixer = floor(time / 12000.0);   
    float fadeMixer = 1 - min(cycleTime / skyFadePeriod, 1);
    
    if (worldTime >= 12000)
    {
        fadeMixer = -fadeMixer;
    }
    
    return mix(day, night, mixer + fadeMixer);
}