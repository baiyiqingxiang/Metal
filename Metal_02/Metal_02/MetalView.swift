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

/** Metal 包含的对象
 * device 从命令队列中消耗渲染和计算命令的GPU的抽象
 * command queue 命令缓冲区的穿行队列 并确定命令顺序执行
 * command buffer 存储来自命令编码器的翻译命令 当缓冲区的命令执行完成时， Metal会通知应用程序
 * command encoder 将API转换成GPU硬件命令 有三种编码器 render（用于图形渲染）、compute（用与数据并行处理）和 blit（用与资源复制操作） render command encoder（RCE）为单个渲染过程产生硬件命令 这将所有渲染发送到单个framebuffer 如果需要渲染另一个framebuffer 则需要创建另一个RCE  RCE为vertex和fragment指定状态 他还交错resources、 state change和draw calls
 * states 混合、深度等
 * shaders 着色器源代码
 * resources 纹理和数据缓冲区
 */
class MetalView : MTKView {
   
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        render()
    }
    
    /*
    func render ()
    {
        // 创建device
        let device = MTLCreateSystemDefaultDevice()!
        // 将创建的device 设置为视图的device 否则将保持nil 且会导致crash 或者可以在绘制之前修改视图的drawable属性
        self.device = device
        // 创建渲染通道描述符
        let rpd = MTLRenderPassDescriptor()
        // 创建clear color
        let bleen = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
        // 使用户当前可绘制纹理作为主要颜色配置渲染通道
        rpd.colorAttachments[0].texture = currentDrawable!.texture
        rpd.colorAttachments[0].clearColor = bleen
        rpd.colorAttachments[0].loadAction = .clear
        // 为该设备创建命令队列
        let commendQueue = device.makeCommandQueue()
        // 利用队列创建一个命令缓冲区
        let commendBuffer = commendQueue?.makeCommandBuffer()
        // 使用命令缓冲区创建渲染命令编码器来执行绘制调用
        let encoder = commendBuffer!.makeRenderCommandEncoder(descriptor: rpd)
        
        encoder!.endEncoding()
        /*
         * 对于每次循环迭代 当从 currentRenderPassDescriptor 查询时 新的MTLRenderPassDescriptor可用， 该对象是继续currentDrawable 对象创建的
         * 示例不是由 MTKView 处理的  所以我们首先检查currentRenderPassDescriptor 和 currentDrawable 都不是nil 然后再调用视图当前drawable上的presentDrawable
         */
        
        commendBuffer!.present(currentDrawable!)
        commendBuffer!.commit()
    }
    */
    func render()
    {
        device = MTLCreateSystemDefaultDevice()
        if let rpd = currentRenderPassDescriptor, currentDrawable != nil
        {
            
            // colorAttaachments 是一组纹理  用于保存绘图结构并显示在屏幕上
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
            let commendBuffer = device!.makeCommandQueue()?.makeCommandBuffer()
            let encoder = commendBuffer!.makeRenderCommandEncoder(descriptor: rpd)
            // 顶点数据
            let vertex_data: [Float] = [-1.0, -1.0, 0.0, 1.0,
                                         1.0, -1.0, 0.0, 1.0,
                                         0.0,  1.0, 0.0, 1.0]
            let size = MemoryLayout.size(ofValue: vertex_data)
            let data_size = vertex_data.count * size
            let vertex_buffer = device!.makeBuffer(bytes: vertex_data, length: data_size, options: [])
            
            let lib = device!.makeDefaultLibrary()
            let vertex_func = lib?.makeFunction(name: "vertex_func")
            let fragment_func = lib?.makeFunction(name: "fragment_func")
            
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vertex_func
            rpld.fragmentFunction = fragment_func
            rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
            let rps = try!device!.makeRenderPipelineState(descriptor: rpld)

            encoder?.setRenderPipelineState(rps)
            encoder?.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
            encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            
            encoder!.endEncoding()
            commendBuffer!.present(currentDrawable!)
            commendBuffer!.commit()
        }
    }
    
}

