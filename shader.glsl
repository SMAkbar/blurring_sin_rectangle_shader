float Band(float t, float start, float end, float blur){
    float step1 = smoothstep(start-blur, start+blur, t);
    float step2 = smoothstep(end+blur, end-blur, t);
    
    return step1 * step2;
}

float Rect(vec2 uv, float left, float right, float top, float bottom, float blur){
    float band1= Band(uv.x, left, right, blur);
    float band2 = Band(uv.y, top, bottom, blur);
    
    return band1 * band2;
}

float remap01(float a, float b, float t){
    return (t-a) / (b-a);
}

float remap(float a, float b, float c, float d, float t){
    return remap01(a, b, t) * (d-c) + c;   
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy; // 0 <> 1
    float time = iTime;
    
    uv -= .5;
    uv.x *= iResolution.x / iResolution.y;
    
    vec3 col = vec3(0.);
    
    float x = uv.x;
    float m = sin(time+x*20.)*0.03;
    float y = uv.y - m;
    
    float blur = remap(-.5, .5, 0.01, .25, x);
    blur *= blur;
    
    float mask = Rect(vec2(x,y), -.5, .5, -.2, .2, blur);
    col = vec3(1., 1., 1.) * mask;
    
    fragColor = vec4(col, 1.0);
    
}