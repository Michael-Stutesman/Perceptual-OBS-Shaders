// ==========================================================
// Temporal Motion Blur — 24/7 Stream Optimized
// Stable Temporal Trail / Motion Response
// Lean Sampling + Linear Filtering
// ==========================================================

uniform texture2d previous_output;

// ---------------- Sliders ----------------
uniform float strength
<
    string label="Motion Strength";
    string widget_type="slider";
    float minimum=0.0;
    float maximum=1.0;
    float step=0.001;
> = 0.7;

uniform float decayClamp
<
    string label="Decay Clamp (Trail Length)";
    string widget_type="slider";
    float minimum=0.0;
    float maximum=0.98;
    float step=0.001;
> = 0.1;

uniform float frameTime
<
    string label="Frame Time (s)";
    string widget_type="slider";
    float minimum=0.0;
    float maximum=0.1;
    float step=0.0001;
> = 0.0;

// ---------------- Sampler ----------------
sampler_state textureSampler
{
    Filter = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

// ---------------- Struct ----------------
struct VertData
{
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

// ==========================================================
// MAIN
// ==========================================================

float4 mainImage(VertData v_in) : TARGET
{
    float2 uv = v_in.uv;

    // ---------------- CURRENT / HISTORY ----------------
    float4 curr = image.Sample(
        textureSampler,
        uv
    );

    float4 prevRaw = previous_output.Sample(
        textureSampler,
        uv
    );

    // ---------------- TEMPORAL SAFETY ----------------
    float historySafe =
        saturate(elapsed_time * 4.0);

    float4 prev =
        lerp(
            curr,
            prevRaw,
            historySafe
        );

    const float3 LUMA =
        float3(0.2126,0.7152,0.0722);

    float lumCurr =
        dot(curr.rgb,LUMA);

    float lumPrev =
        dot(prev.rgb,LUMA);

    // ---------------- MOTION CORE ----------------
    float rawMotion =
        abs(lumCurr - lumPrev);

    float motion =
        saturate(rawMotion * 3.5);

    // Smooth motion response
    motion =
        motion * motion *
        (3.0 - 2.0 * motion);

    // Frame-rate compensation
    motion *=
        0.0167 /
        max(frameTime,0.001);

    // Strength response
    float strengthSq =
        strength * strength;

    float perceptualStrength =
        1.0 -
        exp2(-6.0 * strengthSq);

    float blend =
        min(
            saturate(
                perceptualStrength *
                motion
            ),
            decayClamp
        );

    // ---------------- PIXEL STEP ----------------
    float2 px =
        uv_pixel_interval;

    // ---------------- GRADIENT ----------------
    float lumL =
        dot(
            image.Sample(
                textureSampler,
                uv - float2(px.x,0.0)
            ).rgb,
            LUMA
        );

    float lumR =
        dot(
            image.Sample(
                textureSampler,
                uv + float2(px.x,0.0)
            ).rgb,
            LUMA
        );

    float lumU =
        dot(
            image.Sample(
                textureSampler,
                uv + float2(0.0,px.y)
            ).rgb,
            LUMA
        );

    float lumD =
        dot(
            image.Sample(
                textureSampler,
                uv - float2(0.0,px.y)
            ).rgb,
            LUMA
        );

    float2 grad =
        float2(
            lumR - lumL,
            lumU - lumD
        );

    // ---------------- GRADIENT STABILITY ----------------
    float gradStrength =
        length(grad);

    float2 dir = float2(0.0,0.0);

    if (gradStrength > 1e-4)
    {
        dir =
            grad /
            gradStrength;
    }

    // Suppress weak directional noise
    dir *=
        saturate(
            gradStrength * 8.0
        );

    float2 motionVec =
        dir *
        motion *
        px;

    // ---------------- TEMPORAL BLUR ----------------
    float4 forward =
        previous_output.Sample(
            textureSampler,
            uv - motionVec * 0.50
        );

    float4 backward =
        previous_output.Sample(
            textureSampler,
            uv + motionVec * 0.20
        );

    // Weighted history
    float4 stabilized =
        forward * 0.65 +
        backward * 0.35;

    // ---------------- INERTIA ----------------
    float4 accum =
        lerp(
            prevRaw,
            stabilized,
            0.65
        );

    // ---------------- ANCHOR ----------------
    accum =
        lerp(
            accum,
            curr,
            0.14
        );

    // ---------------- FINAL ----------------
    return lerp(
        curr,
        accum,
        blend
    );
}
