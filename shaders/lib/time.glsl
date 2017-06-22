/**
 * Time utilities. Requires two uniforms:
 * - int worldTime
 * - float frameTime
 */

/**
 * How fast night fades to day, and vice versa in ticks
 */
const int cycleFadePeriod = 200;

float getTimeCycleMixer()
{
    float time = float(worldTime) + frameTime;
    float cycleTime = mod(time, 12000.0);
    
    float mixer = floor(time / 12000.0);   
    float fadeMixer = 1 - min(cycleTime / cycleFadePeriod, 1);
    
    if (worldTime >= 12000)
    {
        fadeMixer = -fadeMixer;
    }
    
    return mixer + fadeMixer;
}