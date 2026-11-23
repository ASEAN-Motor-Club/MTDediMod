// egui mesh shader. Positions arrive in points; `screen` is the target size
// in points. Colours and texels are premultiplied, gamma-space (egui's
// convention), blended as-is into the back buffer.

cbuffer Screen : register(b0) {
    float2 screen;
    float2 pad;
};

struct VSIn {
    float2 pos : POSITION;
    float2 uv  : TEXCOORD0;
    float4 col : COLOR0;
};

struct PSIn {
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
    float4 col : COLOR0;
};

PSIn vs_main(VSIn i) {
    PSIn o;
    o.pos = float4(2.0 * i.pos.x / screen.x - 1.0, 1.0 - 2.0 * i.pos.y / screen.y, 0.0, 1.0);
    o.uv = i.uv;
    o.col = i.col;
    return o;
}

Texture2D tex0 : register(t0);
SamplerState samp0 : register(s0);

float4 ps_main(PSIn i) : SV_TARGET {
    return i.col * tex0.Sample(samp0, i.uv);
}
