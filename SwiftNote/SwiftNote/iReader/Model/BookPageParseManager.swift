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
enum pageContentStyle {
    case min
    case middle
    case normal
    case large
}

/// 解析管理
/// 包括了解析每页的章节字数以及文本的所有内容
class BookPageParseManager: NSObject {
    
    /// 字体大小
    var font = UIFont.systemFont(ofSize: 12)
    
    /// 字体颜色
    var color = UIColor.deepGrayColor()
    
    /// 行间间距
    var lineSpaceing = 12.0
    
    /// 样式类型
    var contentType : pageContentStyle = .normal {
        didSet {
            configurePageViewStyle(contentType)
        }
    }
    

    override init() {
        super.init()
        configurePageViewStyle(contentType)
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
    
    /// 配置最小文本样式
    func configureMinPageViewStyle() {
        font = UIFont.init(name: "ArialMT", size: 12)!
        color = UIColor.deepGrayColor()
        lineSpaceing = 12
    }
    
    /// 配置中等文本样式
    func configureMiddlePageViewStyle() {
        font = UIFont.init(name: "ArialMT", size: 14)!
        color = UIColor.deepGrayColor()
        lineSpaceing = 14
    }
    
    /// 配置正常文本样式
    func configureNormalPageViewStyle() {
        font = UIFont.init(name: "ArialMT", size: 16)!
        color = UIColor.deepGrayColor()
        lineSpaceing = 16
    }
    
    /// 配置最大文本样式
    func configureLargePageViewStyle() {
        font = UIFont.init(name: "ArialMT", size: 18)!
        color = UIColor.deepGrayColor()
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
        
        let filePathString = Bundle.main.path(forResource: bookName!, ofType: "txt")
        
        do {
            return try String(contentsOfFile: filePathString!, encoding: String.Encoding.utf8)
        } catch {}
        
        return ""
    }

    /// 加载本地文件内容
    ///
    /// - Parameters:
    ///   - bookName: 文件名称
    ///   - completion: 完成回调
    class func loadBookInfo(_ bookName : String?, completion : (BookInfoModel?)) {
        
        if bookName == nil {
            if completion != nil {
//                completion(nil)
            }
            return
        }
        
        let contents = loadLocalFile(bookName)
        
        if contents.count == 0 {
            return
        }
        

        if completion != nil {
        }
    }
}
