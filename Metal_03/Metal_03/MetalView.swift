//
        
        
/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** MetalView.swift
 ** Metal_02

 *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Description *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

 ** Author : Vision HIK
 ** Created: 2022/2/12
 ** Revised: Vision HIK
 ** Copyright © 2022 Hangzhou Hikvision Digital Technology Co. LTD. All rights reserved.

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/


    

import Cocoa
import MetalKit

struct Vertex
{
    var position: vector_float4
    var color: vector_float4
}


class MetalView : MTKView {
    
    var vertex_buffer:MTLBuffer!
    var rps:MTLRenderPipelineState! = nil
    
   
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        render()
    }
    func render()
    {
        createDevice()
        createBuffer()
        registerShaders()
        sendCommandToGPU()
        
    }
    func createDevice()
    {
        device = MTLCreateSystemDefaultDevice()
    }
    
    func createBuffer()
    {
        let vertex_data = [Vertex(position: [0.0, 0.5, 0.0, 1.0], color: [1.0, 0.0 ,0.0, 1.0]),
                           Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [0.0, 1.0 , 0.0, 1.0]),
                           Vertex(position: [0.5, -0.5, 0.0, 1.0 ], color: [0.0, 0.0, 1.0, 1.0])]
        let size = MemoryLayout.size(ofValue: vertex_data) * 4 * 2 * 3
        
        vertex_buffer = device!.makeBuffer(bytes: vertex_data, length: size, options: [])
        
    }
    
    func registerShaders()
    {
        let lib = device?.makeDefaultLibrary()
        let vertex_func = lib?.makeFunction(name: "vertex_func")
        let fragment_func = lib?.makeFunction(name: "fragment_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vertex_func
        rpld.fragmentFunction = fragment_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try rps = device?.makeRenderPipelineState(descriptor: rpld)
        } catch let error {
            print(error)
        }
    }
    func sendCommandToGPU()
    {
        if let rpd = currentRenderPassDescriptor, currentDrawable != nil
        {
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0)
            let command_buffer = device?.makeCommandQueue()?.makeCommandBuffer()
            let encoder = command_buffer?.makeRenderCommandEncoder(descriptor: rpd)
            encoder?.setRenderPipelineState(rps)
            encoder?.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
            encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            encoder?.endEncoding()
            command_buffer?.present(currentDrawable!)
            command_buffer?.commit()
        }
    }
    
    
//    func render()
//    {
//        device = MTLCreateSystemDefaultDevice()
//        if let rpd = currentRenderPassDescriptor, currentDrawable != nil
//        {
//
//            // colorAttaachments 是一组纹理  用于保存绘图结构并显示在屏幕上
//            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0,
//                                                               green: 0.5,
//                                                               blue: 0.5,
//                                                               alpha: 1)
//            let commendBuffer = device!.makeCommandQueue()?.makeCommandBuffer()
//            let encoder = commendBuffer!.makeRenderCommandEncoder(descriptor: rpd)
//            // 顶点数据
//            let vertex_data: [Float] = [-1.0, -1.0, 0.0, 1.0,
//                                         1.0, -1.0, 0.0, 1.0,
//                                         0.0,  1.0, 0.0, 1.0]
//            let size = MemoryLayout.size(ofValue: vertex_data)
//            let data_size = vertex_data.count * size
//            let vertex_buffer = device!.makeBuffer(bytes: vertex_data,
//                                                   length: data_size,
//                                                   options: [])
//
//            let lib = device!.makeDefaultLibrary()
//            let vertex_func = lib?.makeFunction(name: "vertex_func")
//            let fragment_func = lib?.makeFunction(name: "fragment_func")
//
//            let rpld = MTLRenderPipelineDescriptor()
//            rpld.vertexFunction = vertex_func
//            rpld.fragmentFunction = fragment_func
//            rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
//            let rps = try!device!.makeRenderPipelineState(descriptor: rpld)
//
//            encoder?.setRenderPipelineState(rps)
//            encoder?.setVertexBuffer(vertex_buffer,
//                                     offset: 0,
//                                     index: 0)
//            encoder?.drawPrimitives(type: .triangle,
//                                    vertexStart: 0,
//                                    vertexCount: 3,
//                                    instanceCount: 1)
//
//            encoder!.endEncoding()
//            commendBuffer!.present(currentDrawable!)
//            commendBuffer!.commit()
//        }
//    }
    
   
}

