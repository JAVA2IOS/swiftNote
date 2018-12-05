//
//  BookChapterModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookChapterModel: NSObject {
    var chapterId : String!
    var bookId : String!
    var contentModels : Array<BookContentModel>!
    
    override init() {
        
        super.init()
    }

}
