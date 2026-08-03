uniform texture2d previous_output;

// ---------------- Sliders ----------------
uniform float strength    < string label="Motion Strength"; string widget_type="slider"; float minimum=0.0; float maximum=1.0; float step=0.001; > = 0.7;
uniform float decayClamp  < string label="Decay Clamp (Trail Length)"; string widget_type="slider"; float minimum=0.0; float maximum=0.98; float step=0.001; > = 0.05;
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

float4 mainImage(VertData v_in) : TARGET
{
    float2 uv = v_in.uv;

    float4 curr = image.Sample(textureSampler, uv);
    float4 prevRaw = previous_output.Sample(textureSampler, uv);

    // ---------------- TEMPORAL SAFETY ----------------
    float historySafe = saturate(elapsed_time * 4.0);
    float4 prev = lerp(curr, prevRaw, historySafe);

    const float3 LUMA = float3(0.2126, 0.7152, 0.0722);

    float lumCurr = dot(curr.rgb, LUMA);
    float lumPrev = dot(prev.rgb, LUMA);

    // ---------------- STABLE MOTION CORE ----------------
    float rawMotion = abs(lumCurr - lumPrev);

    // soften spikes (key improvement)
    float motion = saturate(rawMotion * 3.5);

    // curve compression (prevents flicker amplification)
    motion = motion * motion * (3.0 - 2.0 * motion);

    motion *= 0.0167 / max(frameTime, 0.001);

    float perceptualStrength = 1.0 - exp2(-6.0 * strength * strength);
    float depthFactor = lerp(1.0 - depthWeight, 1.0, lumCurr);

    float blend = min(
        saturate(perceptualStrength * motion * depthFactor),
        decayClamp
    );

    float2 px = uv_pixel_interval;

    // ---------------- STABLE GRADIENT ----------------
    float lumL = dot(image.Sample(textureSampler, uv - float2(px.x, 0)).rgb, LUMA);
    float lumR = dot(image.Sample(textureSampler, uv + float2(px.x, 0)).rgb, LUMA);
    float lumU = dot(image.Sample(textureSampler, uv + float2(0, px.y)).rgb, LUMA);
    float lumD = dot(image.Sample(textureSampler, uv - float2(0, px.y)).rgb, LUMA);

    float2 grad = float2(lumR - lumL, lumU - lumD);

    // stabilize weak gradients (prevents jitter)
    float gradStrength = length(grad);
    float2 dir = (gradStrength > 1e-4)
        ? grad / gradStrength
        : float2(0.0, 0.0);

    // soften direction response (key stability layer)
    dir *= saturate(gradStrength * 8.0);

    float2 motionVec = dir * motion * px;

    // ---------------- STABILIZED TEMPORAL BLUR ----------------
    float4 history = previous_output.Sample(textureSampler, uv);

    float4 forward  = previous_output.Sample(textureSampler, uv - motionVec * 0.55);
    float4 backward = previous_output.Sample(textureSampler, uv + motionVec * 0.25);

    float4 stabilized = (forward * 0.6 + backward * 0.4);

    // inertia smoothing (reduces “drag jitter”)
    float4 accum = lerp(history, stabilized, 0.5);

    // anchor to prevent overshoot drift
    accum = lerp(accum, curr, 0.06);

    return lerp(curr, accum, blend);
}
