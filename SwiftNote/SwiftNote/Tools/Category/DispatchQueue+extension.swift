//
//  DispatchQueue+extension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/19.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

typealias queueCallBack = () -> Void

extension DispatchQueue {
    
    class func queueBlock(queue : DispatchQueue, async : Bool = true, _ block : @escaping queueCallBack) {
        if async {
            queue.async {
                block()
            }
        }else {
            queue.sync {
                block()
            }
        }
    }
    
    class func asyncQueue(queue : DispatchQueue, _ block : @escaping queueCallBack) {
        queueBlock(queue: queue, block)
    }
    
    /// 主队列
    ///
    /// - Parameter block: 回调方法
    class func mainQueue(_ block : @escaping queueCallBack) {
        queueBlock(queue: DispatchQueue.main, async: false, block)
    }
    
    /// 全局队列调用
    ///
    /// - Parameter block: 回调方法
    class func gloableQueue(_ block : @escaping queueCallBack) {
        queueBlock(queue: DispatchQueue.global(), block)
    }
    
    /// 组队列
    ///
    /// - Parameters:
    ///   - queue: 队列
    ///   - progress: 队列使用过程
    ///   - notify: 所有队列方法完成后回调
    class func groupQueue(queue : DispatchQueue = DispatchQueue.global(), progress : @escaping (DispatchQueue ,DispatchGroup) -> Void , notify : @escaping queueCallBack) {
        let group = DispatchGroup()
        
        progress(queue,group)
        
        group.notify(queue: DispatchQueue.main) {
            notify()
        }
    }
}
