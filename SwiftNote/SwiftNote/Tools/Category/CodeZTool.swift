//
//  CodeZTool.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/14.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation

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
    
}
