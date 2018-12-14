//
//  UserDefaults+Extension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/12.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

protocol UserDefaultsSettable {
    associatedtype storageKeys : RawRepresentable
}

// MARK: - 扩展协议，默认实现方法
extension UserDefaultsSettable where storageKeys.RawValue == String {
    /// 将值缓存到本地
    ///
    /// - Parameters:
    ///   - value: 待缓存的值
    ///   - key: 缓存的键名
    static func store(_ value : Any?, for key: storageKeys) -> Void {
        let storeKey = "\(Self.self)_" + key.rawValue
        
        UserDefaults.standard.set(value, forKey: storeKey)
    }
    
    
    /// 从本地缓存中获取值
    ///
    /// - Parameter key: 键名
    /// - Returns: 值
    static func valueFromStore(_ key : storageKeys) -> Any? {
        let storeKey = "\(Self.self)_" + key.rawValue

        return  UserDefaults.standard.value(forKey: storeKey)
    }
}

extension UserDefaults {
    struct iBook : UserDefaultsSettable {
        enum storageKeys : String {
            case bookStyle
            case chapter
            case bookRemarks
            case books
        }
    }
}
