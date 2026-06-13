uniform texture2d previous_output;

// ---------------- Sliders ----------------
uniform float strength    < string label="Motion Strength"; string widget_type="slider"; float minimum=0.0; float maximum=1.0; float step=0.001; > = 0.7;
uniform float decayClamp  < string label="Decay Clamp (Trail Length)"; string widget_type="slider"; float minimum=0.0; float maximum=0.98; float step=0.001; > = 0.03;
uniform float depthWeight < string label="Depth Influence on Trails"; string widget_type="slider"; float minimum=0.0; float maximum=1.0; float step=0.001; > = 0.0;
uniform float frameTime   < string label="Frame Time (s)"; string widget_type="slider"; float minimum=0.0; float maximum=0.1; float step=0.0001; > = 0.0;

// ---------------- Sampler ----------------
sampler_state textureSampler 
{ 
    Filter        = Anisotropic; 
    MaxAnisotropy = 8; 
    AddressU      = Clamp; 
    AddressV      = Clamp; 
};

struct VertData { float4 pos : POSITION; float2 uv : TEXCOORD0; };

// ---------------- Main Shader ----------------
float4 mainImage(VertData v_in) : TARGET
{
    float2 uv = v_in.uv;

    float4 curr = image.Sample(textureSampler, uv);
    float4 prevRaw = previous_output.Sample(textureSampler, uv);

    // -------------------------------------------------
    // 🧊 HISTORY SAFETY LAYER (ONLY CHANGE THAT MATTERS)
    // Smoothly introduces history over first frames
    // -------------------------------------------------
    float historySafe = saturate(elapsed_time * 4.0);
    float4 prev = lerp(curr, prevRaw, historySafe);

    const float3 LUMA = float3(0.2126,0.7152,0.0722);

    float lumCurr = dot(curr.rgb, LUMA);
    float lumPrev = dot(prev.rgb, LUMA);

    float motion = saturate(abs(lumCurr - lumPrev) * 4.0 * (0.0167 / max(frameTime,0.001)));

    float perceptualStrength = 1.0 - exp2(-6.0 * strength * strength);
    float depthFactor = lerp(1.0 - depthWeight, 1.0, lumCurr);

    float blend = min(saturate(perceptualStrength * motion * depthFactor), decayClamp);

    float2 px = uv_pixel_interval;

    float lumH = dot(image.Sample(textureSampler, uv + float2(px.x,0)).rgb -
                     image.Sample(textureSampler, uv - float2(px.x,0)).rgb, LUMA);

    float lumV = dot(image.Sample(textureSampler, uv + float2(0,px.y)).rgb -
                     image.Sample(textureSampler, uv - float2(0,px.y)).rgb, LUMA);

    float2 blurDir = -normalize(float2(lumH, lumV) + 1e-6);

    // ---------------- Hardcoded 7 Subsamples ----------------
    float4 accum =
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(1.0/7.0)*1.0) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(1.0/7.0)*1.5) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(1.0/7.0)*2.0) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(2.0/7.0)*1.0) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(2.0/7.0)*1.5) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(2.0/7.0)*2.0) * 0.142857 +
        previous_output.Sample(textureSampler, uv - blurDir*motion*px*(3.0/7.0)*1.0) * 0.142857;

    // ---------------- Final Blend ----------------
    return lerp(curr, accum, blend);
}
