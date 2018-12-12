//
//  BookInfoModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/12.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookInfoModel: NSObject {
    /// 小说id
    var bookId : String?
    
    /// 小说名称
    var bookName : String?
    
    
    /// 章节列表
    var chapterList : Array<BookChapterModel>?
    
    
    // MARK: - 历史记录
    /// 历史章节记录
    var historyChapter : BookChapterModel?
    
    /// 起始位置记录
    var location : NSRange = NSMakeRange(0, 0)
    
    // MARK: - 书签列表
    
    override init() {
        super.init()
    }
    
    class func checkLocalBookInfo(_ bookName : String?) -> BookInfoModel? {
        if (bookName?.isEmpty)! {
            return nil
        }
        
        let bookInfo = BookInfoModel.init()
        
        bookInfo.bookId = "1"
        bookInfo.bookName = bookName!
        
        if bookInfo.historyChapter == nil {
            let chapterModel = BookChapterModel.init()
            chapterModel.bookId = bookInfo.bookId

            bookInfo.historyChapter = chapterModel
        }
        
        return bookInfo
    }
}
