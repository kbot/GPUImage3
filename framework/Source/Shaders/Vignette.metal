#include <metal_stdlib>
#include "../Operations/OperationShaderTypes.h"
using namespace metal;

typedef struct {
    float vignetteEnd;
    float vignetteStart;
    float2 vignetteCenter;
    float3 vignetteColor;
} VignetteUniform;

fragment half4 vignetteFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                       texture2d<half> inputTexture [[texture(0)]],
                                       constant VignetteUniform& uniform [[buffer(1)]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    float d = distance(fragmentInput.textureCoordinate, float2(uniform.vignetteCenter.x, uniform.vignetteCenter.y));
    float percent = smoothstep(uniform.vignetteStart, uniform.vignetteEnd, d);
    return half4(mix(color.rgb, half3(uniform.vignetteColor), half(percent)), color.a);
}
