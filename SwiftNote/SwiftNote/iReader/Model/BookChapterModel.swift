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
    var bookId : String!
    /// 章节id
    var chapterId : String!
    /// 分页内容
    var contentModels : Array<BookContentModel>?
    
    override init() {
        super.init()
    }

    
    /// 更新分页内容样式
    func updateBookStyle() {
        
    }
}
