//
//  BookChapterModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookChapterModel: NSObject {
    /// 小说id
    @objc var bookId : String!
    /// 章节id
    @objc var chapterId : String!
    /// 分页内容
    @objc var contentModels : Array<BookContentModel>?
    
    override init() {
        super.init()
    }

    
    /// 更新分页内容样式
    func updateBookStyle() {
        
    }
    
    override func yy_modelDescription() -> String {
        return self.yy_modelToJSONString()!
    }
}
