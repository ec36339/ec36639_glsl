// Collection of shaping functions from https://thebookofshaders.com/05/ and other sources.

// Function plotting shader:
// Author: Inigo Quiles
// Title: Expo

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

// SHAPING FUNCTIONS

// Digital pulse (from "Texturing & Modeling - A Procedural Approach")
float pulse(float a, float b, float x)
{
    return step(a, x) - step(b, x);
}

// Cubic step function (like smoothstep(0.0, 1.0, x))
float cubic(float x)
{
    return x * x * (3.0 - 2.0 * x);
}

float cubicPulse(float c, float w, float x)
{
	//  Function from Iñigo Quiles
	//  www.iquilezles.org/www/articles/functions/functions.htm
    x = abs(x - c);
    if (x > w) return 0.0;
    x /= w;
    return 1.0 - cubic(x);
}

// Raised invertex cosine (authentic)
float raisedInvCos(float x)
{
    return 1.0 - (cos(x * PI) / 2.0 + 0.5);
}

// Raised invertex cosine (Blinn-Wyvill approximation)
float blinnWyvillCosineApprox(float x)
{
    float x2 = x*x;
    float x4 = x2*x2;
    float x6 = x4*x2;
    
    const float fa = 4.0 / 9.0;
    const float fb = 17.0 / 9.0;
    const float fc = 22.0 / 9.0;
    
    return fa*x6 - fb*x4 + fc*x2;
}

float quadraticBezier(float x, float a, float b)
{
    // from http://www.flong.com/archive/texts/code/shapers_bez/
    // adapted from BEZMATH.PS (1993)
    // by Don Lancaster, SYNERGETICS Inc. 
    // http://www.tinaja.com/text/bezmath.html
    float epsilon = 0.00001;
    a = clamp(a, 0.0, 1.0);
    b = clamp(b, 0.0, 1.0);
    if (a == 0.5) {
		a += epsilon;
    }

    // solve t from x (an inverse operation)
    float om2a = 1.0 - 2.0 * a;
    float t = (sqrt(a * a + om2a * x) - a) / om2a;
    float y = (1.0 - 2.0 * b) * (t * t) + (2.0 * b)*t;
    return y;
}

// Gamma correction
float gamma(float gamma, float x)
{
    return pow(x, 1.0 / gamma);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = cubicPulse(0.5, 0.25, st.x);
	
    vec3 color = vec3(y);

    float pct = plot(st,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(color,1.0);
}
