/**
 * This file stores code that isn't necessarily used in the shader itself, 
 * however this code is too cool to remove at all.
 */

/**
 * Psychodelic waving (gbuffers, vertex shader) 
 */
float len = min(-gl_Position.z + 25, 0);

if (len < 0)
{
    gl_Position.y += sin(len / 2 + frameTimeCounter) * min(len / 50, -1);
}