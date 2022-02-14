//
/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** Shaders.metal
 ** Metal_02

 *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Description *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** Author : Vision HIK
 ** Created: 2022/2/14
 ** Revised: Vision HIK
 ** Copyright © 2022 Hangzhou Hikvision Digital Technology Co. LTD. All rights reserved.

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/


#include <metal_stdlib>
using namespace metal;


struct Vertex {
    float4 position[[position]];
};

vertex Vertex vertex_func(constant Vertex * vertices[[buffer(0)]], uint vid[[vertex_id]]) {
    return  vertices[vid];
}

fragment float4 fragment_func(Vertex vert[[stage_in]])
{
    return  float4(0.7,1,1,1);
}
