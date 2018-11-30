//
//  String+extension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/13.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import Foundation

// MARK: - String 的扩展
extension String {
    
    /// 获得最后一个字符串
    ///
    /// - Returns: 最后一个字符串
    func cz_getLastString() -> String {
        let lastChar : Character = self.last!
        return String(lastChar)
    }
}
