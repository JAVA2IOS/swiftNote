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
    
    /// 章节标题
    @objc var chapterTitle : String!
    
    /// 起始坐标
    @objc var firstCharacter : Int = 0
    
    /// 终止坐标
    @objc var lastCharacter : Int = 0
    
    /// 排序
    @objc var sort : Int = 0
    
    /// 章节内容
    @objc var contents : String!
    
    /// 分页内容
    @objc var contentModels : Array<BookContentModel>?
    
    /// 是否能够切割(方便计算当前章节文本内容)
    @objc var canCutting : Bool = false
    
    /// 是否是最后一个章节
    @objc var lastChapter : Bool = false
    
    /// 是否是第一个章节
    @objc var firstChapter : Bool = false
    
    override init() {
        super.init()
    }

    
    /// 更新分页内容样式
    func updateBookStyle() {
        
    }
    
    /// 配置章节内容
    ///
    /// - Parameter completion: 章节内容
    func configureContentsModels(_ completion : @escaping () -> Void) {
        BookPageParseManager.sharedInstance.loadChapterModel(contents) { (contentModels) in
            self.contentModels = contentModels
            completion()
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
