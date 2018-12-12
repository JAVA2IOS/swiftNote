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
    var bookId : String!
    
    /// 章节id
    var chapterId : String!
    
    /// 内容范围
    var location : NSRange = NSMakeRange(0, 0)
    
    /// 排列顺序
    var characterSort : Int!
    
    /// 内容文本
    var content : String!
    
    override init() {
        
        super.init()
    }

}
