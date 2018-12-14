//
//  BookPageParseManager.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/12.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

/// 文本样式
///
/// - min: 最小
/// - middle: 中等
/// - normal: 正常
/// - large: 最大
@objc enum pageContentStyle : Int {
    case min
    case middle
    case normal
    case large
}

/// 解析管理
/// 包括了解析每页的章节字数以及文本的所有内容
class BookPageParseManager: NSObject {
    
    /// 字体大小
    @objc var font : Int = 12
    
    /// 字体颜色
    @objc var color : String = "878D94"
    
    /// 行间间距
    @objc var lineSpaceing : Float = 12.0
    
    /// 每页的字数
    @objc var pageSize : Int = 100
    
    /// 样式类型
    @objc var contentType : pageContentStyle = .normal {
        didSet {
            configurePageViewStyle(contentType)
        }
    }
    
    /// 单例变量
    static let sharedInstance = BookPageParseManager()
    
    private override init() {
        super.init()
        let cachedLocalData = UserDefaults.iBook.valueFromStore(.bookStyle)

        if cachedLocalData != nil {
            let dic = cachedLocalData as! Dictionary<String, Any>
            contentType = pageContentStyle(rawValue: dic["contentType"] as! Int)!
            font = dic["font"] as! Int
            color = dic["color"] as! String
            lineSpaceing = dic["lineSpaceing"] as! Float
            pageSize = dic["pageSize"] as! Int
        }else {
            configurePageViewStyle(contentType)
            UserDefaults.iBook.store(self.yy_modelToJSONObject(), for: .bookStyle)
        }
    }

    /// 配置文本样式
    ///
    /// - Parameter styleType: 文本样式类型
    private func configurePageViewStyle(_ styleType : pageContentStyle) {
        switch styleType {
        case .min:
            configureMinPageViewStyle()
            break
        case .middle:
            configureMiddlePageViewStyle()
            break
        case .normal:
            configureNormalPageViewStyle()
            break
        case .large:
            configureLargePageViewStyle()
            break
        }
    }
    
    /// 缓存本地
    func cacheInLocal() {
    }
    
    /// 配置最小文本样式
    func configureMinPageViewStyle() {
//        font = UIFont.init(name: "ArialMT", size: 12)!
        font = 12
        lineSpaceing = 12
    }
    
    /// 配置中等文本样式
    func configureMiddlePageViewStyle() {
//        font = UIFont.init(name: "ArialMT", size: 14)!
        font = 14
        lineSpaceing = 14
    }
    
    /// 配置正常文本样式
    func configureNormalPageViewStyle() {
//        font = UIFont.init(name: "ArialMT", size: 16)!
        font = 16
        lineSpaceing = 16
    }
    
    /// 配置最大文本样式
    func configureLargePageViewStyle() {
//        font = UIFont.init(name: "ArialMT", size: 18)!
        font = 18
        lineSpaceing = 18
    }
    
    /// 加载本地文件
    ///
    /// - Parameter bookName: 字体名称，不包括txt后缀
    /// - Returns: 文件内容
    class func loadLocalFile(_ bookName : String?) -> String {
        if bookName == nil {
            return ""
        }
        
        let filePathString = CZTools.fileDocumentFilePath(bookName! + ".txt")
        
        if filePathString == nil {
            return ""
        }

        do {
            var contents = try String(contentsOfFile: filePathString!, encoding: String.Encoding.unicode)
            
            if contents == "" {
                contents = try String(contentsOfFile: filePathString!, encoding: String.Encoding.utf8)
            }
            
            return contents
        } catch let error as NSError {
            print("读取文件异常：\(error.localizedDescription)")
        }
        
        return ""
    }

    /// 加载本地文件内容
    ///
    /// - Parameters:
    ///   - bookName: 文件名称
    ///   - completion: 完成回调
    class func loadBookInfo(_ bookName : String?, completion : (BookInfoModel?) -> Void) {
        
        if bookName == nil {
            completion(nil)
            return
        }
        
        let contents = loadLocalFile(bookName)
        
        if contents.count == 0 {
            completion(nil)
            return
        }
        
        let dataArray = UserDefaults.iBook.valueFromStore(.books)
        
        var bookInfo = BookInfoModel.init()
        if dataArray == nil {
            bookInfo.bookId = "gzr"
            bookInfo.bookName = bookName!
            bookInfo.location = 0
            
            UserDefaults.iBook.store([bookInfo.yy_modelToJSONObject()], for: .books)
        }else {
            let books = dataArray as! Array<Dictionary<String, Any>>
            
            let bookInfos = books.filter { (bookInfo) -> Bool in
                let book = BookInfoModel.yy_model(withJSON: bookInfo)
                
                if book!.bookId == "gzr" {
                    return true
                }
                
                return false
            }
            
            if bookInfos.count != 0 {
                bookInfo = BookInfoModel.yy_model(withJSON: bookInfos.first as Any)!
            }else {
                bookInfo.bookId = "gzr"
                bookInfo.bookName = bookName!
                bookInfo.location = 0
                
                UserDefaults.iBook.store([bookInfo.yy_modelToJSONObject()], for: .books)
            }
        }

        completion(bookInfo)
    }
}
