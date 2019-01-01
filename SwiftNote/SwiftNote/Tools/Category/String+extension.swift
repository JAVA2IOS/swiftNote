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
    
    /// 截取字符串
    ///
    /// - Parameter range: 字符串截取的范围
    /// - Returns: 截取的字符串
    func cz_subString(range : NSRange) -> String {
        let maxIndex = max(range.location, 0)
        let startIndex = self.index(self.startIndex, offsetBy: maxIndex)
        let minIndex = min(self.count, range.upperBound)
        
        let endIndex = self.index(self.startIndex, offsetBy: minIndex)
        
        let subString = String(self[startIndex..<endIndex])
        
        return subString
    }
    
    /// 正则表达式过滤后得到字符的范围
    ///
    /// - Parameter pattern: 正则表达式
    /// - Returns: 字符串的范围
    func rangesInRegularExpression(_ pattern : String) -> [NSRange] {
        do {
            let regularExpressions = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let results = regularExpressions.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))
            
            var ranges = [NSRange]()
            
            for (_ , value) in results.enumerated() {
                ranges.append(value.range)
            }
            
            return ranges
        } catch  {
        }
        
        return []
    }
    
    /// 正则表达式过滤
    ///
    /// - Parameter pattern: 正则表达式
    /// - Returns: 过滤后的字符串数组结合
    func filterInRegularExpression(_ pattern : String) -> [[String : Any]]? {
        do {
            let regularExpressions = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let results = regularExpressions.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))
            
            var filterStrings : [[String : Any]] = Array()
            
            for result in results {
                let subString = cz_subString(range: result.range)
                filterStrings.append(["location" : result.range.location, "contents" : subString])
            }
            
            return filterStrings
            
        } catch {
            return nil
        }
    }
    
    /// 过滤字符串
    ///
    /// - Parameter charcaterString: 待过滤的字符串
    /// - Returns: 过滤后的字符串
    @discardableResult
    mutating func cz_removeString(_ charcaterString : String) -> String {
        return cz_replaceString(replacedCharacter: charcaterString, newCharacter: "")
    }
    
    /// 替换字符串
    ///
    /// - Parameters:
    ///   - replacedCharacter: 需要被替换的字符
    ///   - newCharacter: 替换后的字符
    /// - Returns: 新的字符串
    @discardableResult
    mutating func cz_replaceString(replacedCharacter : String, newCharacter : String) -> String {
        self = self.replacingOccurrences(of: replacedCharacter, with: newCharacter)
        return self
    }
}


// MARK: - 编码格式扩展
extension String.Encoding {

    public static var GBK : String.Encoding {
        return String.Encoding(rawValue: 0x80000632)
    }
    
    
    public static var GB18030 : String.Encoding {
        return String.Encoding(rawValue: 0x80000631)
    }
}
