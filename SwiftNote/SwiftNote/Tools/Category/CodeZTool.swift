//
//  CodeZTool.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/14.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

enum systemVariableName {
    case bundleIdentity
    case bundleDisplayName
    case appVersion
    case iOSVersion
    case systemName
    case systemModel
    case systemModelName
    case systemUUid
    case systemIDFA
    case phoneName
}

/// 工具类
class CZTools: NSObject {
    
    // MARK: - file path 文件路径
    
    /// documentPath路径
    class var fileDocumentPath : String {
        get {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
    }
    
    /// NSBundle.mainBundle路径
    class var fileMainBundlePath : String {
        get {
            return Bundle.main.resourcePath!
        }
    }
    
    /// 沙盒documents中的文件路径
    ///
    /// - Parameter fullFileName: 文件全名
    /// - Returns: 文件的完整路径
   class func fileDocumentFilePath(_ fullFileName : String?) -> String? {
        if fullFileName == nil {
            return nil
        }
    
        return fileDocumentPath + "/" + fullFileName!
    }
    
    /// 返回NSBundle.mainBundle下的文件路径
    ///
    /// - Parameter fullFileName: 文件全名(name.fileType)
    /// - Returns: 文件完整路径，如果文件名为空，返回bundle路径
    class func fileMainBundleFilePath(_ fullFileName : String?) -> String {
        if fullFileName == nil {
            return fileMainBundlePath
        }
        return fileMainBundlePath + "/" + fullFileName!
    }
    
    /// 根据文件名查找NSBundle.mainBundle文件的完整路径
    ///
    /// - Parameter fullFileName: 文件全名
    /// - Returns: 文件路径
    class func fileMainBundleSearchFilePath(_ fullFileName : String?) -> String? {
        if fullFileName == nil {
            return nil
        }
        
        let fileNamesPath = fullFileName!.components(separatedBy: ".")
        
        if fileNamesPath.count != 2 {
            return nil
        }
        
        let fileName = fileNamesPath.first!
        
        let fileType = fileNamesPath.last!
        
        return Bundle.main.path(forResource: fileName, ofType: fileType)
    }
    
    /// 将文件拷贝到沙盒目录下
    ///
    /// - Parameter filePath: 文件完整目录
    /// - Returns: 是否拷贝成功
    class func fileCopyToSanBoxDocumentsPath(_ filePath : String?) -> Bool {
        if filePath == nil {
            return false
        }
        
        let bundlePaths = filePath?.components(separatedBy: "/")
        if bundlePaths?.count == 0 {
            return false
        }
        
        let fileName = bundlePaths!.last
        
        let documentExistedFilePath = fileDocumentPath + "/" + fileName!

        
        // 判断路径下是否存在文件
        if FileManager.default.fileExists(atPath: documentExistedFilePath) {
            return true
        }
        
        let sanboxPath = self.fileDocumentPath + "/" + fileName!
        
        do {
            try FileManager.default.copyItem(atPath: filePath!, toPath: sanboxPath)
            return true
        } catch {
        }
        
        return false
    }
    
    
    // MARK: - 系统变量
    
    /// bundleId
    class var systemBundleIdentifier : String {
        get {
            return systemVariable(.bundleIdentity)!
        }
    }
    
    /// bundleName
    class var systemBundleName: String {
        get {
            return systemVariable(.bundleDisplayName)!
        }
    }
    
    /// app版本号
    class var appVersion: String {
        get {
            return systemVariable(.appVersion)!
        }
    }
    
    /// iOS系统版本号
    class var iOSVersion : String {
        get {
            return systemVariable(.iOSVersion)!
        }
    }
    
    /// 系统名称 iOS
    class var systemName : String {
        get {
            return systemVariable(.systemName)!
        }
    }
    
    /// 系统设备名称  e.g "iphone 6"
    class var systemModel : String {
        get {
            return systemVariable(.systemModel)!
        }
    }
    
    /// uuid
    class var systemUUID : String {
        get {
            return systemVariable(.systemUUid)!
        }
    }
    
    /// 系统广告id
    class var systemIDFA : String {
        get {
            return systemVariable(.systemIDFA)!
        }
    }
    
    /// 手机名称 e.g "my iphne"
    class var phoneName : String {
        get {
            return systemVariable(.phoneName)!
        }
    }
    
    class func systemVariable(_ systemType : systemVariableName) -> String? {
        switch systemType {
        case .appVersion:
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        case .bundleIdentity:
            return Bundle.main.bundleIdentifier
        case .bundleDisplayName:
            return Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
        case .iOSVersion:
            return UIDevice.current.systemVersion
        case .systemName:
            return UIDevice.current.systemName
        case .systemModel:
            return UIDevice.current.model
        case .systemModelName:
            return UIDevice.current.model
        case .systemUUid:
            return UIDevice.current.identifierForVendor?.uuidString
        case .systemIDFA:
            return UIDevice.current.identifierForVendor?.uuidString
        case .phoneName:
            return UIDevice.current.name
        }
    }
}
