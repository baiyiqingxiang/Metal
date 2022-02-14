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
    float4 color;
};


vertex // 函数限定符  只能具有vertex fragment或者kernel 的值
Vertex // 返回值类型
vertex_func // 函数名
// Metal shading language 限制指针的使用除非参数是device 、threadgroup 或者 constant地址空间限定符声明
// 该设备、线程组或者地址空间限定符指定分配函数变量或参数的内存区域
// [[...]]语法用于声明属性，如资源位置，子着色器输入以及在着色器和CPU志坚来回传递的内置变量
// vid 用来索引Metal 将当前正在初六的顶点缩影作为参数插入
(constant Vertex * vertices[[buffer(0)]], uint vid[[vertex_id]]) {
    
    return  vertices[vid];
}

fragment float4 fragment_func(Vertex vert[[stage_in]])
{
//    return  float4(0.7,1,1,1);
    return vert.color;
}
