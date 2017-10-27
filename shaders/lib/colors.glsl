/* Colors */

#define rgb(x, y, z) (vec3(x, y, z) / 255.0)

/* Day time sky colors */
const vec3 zenith_color = rgb(120, 40, 20);
const vec3 horizon_color = rgb(255, 225, 150);
const vec3 void_color = rgb(90, 0, 0);

/* Night time sky colors */
const vec3 night_zenith_color = rgb(10, 10, 69);
const vec3 night_horizon_color = rgb(20, 60, 166);
const vec3 night_void_color = rgb(61, 40, 91);

/* Light map colors */
const vec3 light_source = rgb(255, 180, 0) * 2;
const vec3 light_destination = rgb(62, 90, 125);
const vec3 light_sky = rgb(255, 255, 255);

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}