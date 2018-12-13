//
//  BookContentModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookContentModel: NSObject {
    /// 小说id
    @objc var bookId : String!
    
    /// 章节id
    @objc var chapterId : String!
    
    /// 内容范围
    @objc var location : Int = 0
    
    /// 排列顺序
    @objc var characterSort : Int = 0
    
    /// 内容文本
    @objc var content : String!
    
    override init() {
        
        super.init()
    }

    override func yy_modelDescription() -> String {
        return self.yy_modelToJSONString()!
    }
}
