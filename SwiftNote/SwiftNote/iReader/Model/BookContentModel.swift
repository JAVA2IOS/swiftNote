//
//  BookContentModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookContentModel: NSObject {
    var bookId : String!
    var chapterId : String!
    var characterStart : Int!
    var characterEnd : Int!
    
    var content : String!
    
    override init() {
        
        super.init()
    }

}
