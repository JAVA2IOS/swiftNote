//
//  NSObject+extension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/13.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

//protocol swiftyJsonMapple {
//    func jsonToObject(_ jsonData : JSON)
//
//
//}

extension NSObject : YYModel {
    func jsonToObject() {
        let mirror = Mirror(reflecting: self)
        
        for item in mirror.children {
            let type = Mirror(reflecting: item.value).subjectType
            
            print("\(item) 类型 : \(type)")
        }
    }
}
