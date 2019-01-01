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

/// 书籍内容以及坐标范围
struct BookContents {
    var range : NSRange = NSRange(location: 0, length: 0)
    var contents : String = ""
    
}

/// 解析管理
/// 包括了解析每页的章节字数以及文本的所有内容
class BookPageParseManager: NSObject, DataBaseProtocol {
    
    /// 字体大小
    @objc var font : Int = 12
    
    /// 字体颜色
    @objc var color : String = "878D94"
    
    /// 字体样式
    @objc var fontName : String = "ArialMT"
    
    /// 行间间距
    @objc var lineSpacing : Float = 12.0
    
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
        
        let instance = instanceForPrimaryKey(1)
        
        if instance == nil {
            configurePageViewStyle(contentType)
            save()
        } else {
            
            let dic = instance as! Dictionary<String, Any>
            contentType = pageContentStyle(rawValue: dic["styleType"] as! Int)!
            font = dic["font"] as! Int
            fontName = dic["fontName"] as! String
            color = dic["color"] as! String
            lineSpacing = Float(dic["lineSpacing"] as! Int)
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
        lineSpacing = 12
    }
    
    /// 配置中等文本样式
    func configureMiddlePageViewStyle() {
        //        font = UIFont.init(name: "ArialMT", size: 14)!
        font = 14
        lineSpacing = 14
    }
    
    /// 配置正常文本样式
    func configureNormalPageViewStyle() {
        //        font = UIFont.init(name: "ArialMT", size: 16)!
        font = 16
        lineSpacing = 16
    }
    
    /// 配置最大文本样式
    func configureLargePageViewStyle() {
        //        font = UIFont.init(name: "ArialMT", size: 18)!
        font = 18
        lineSpacing = 18
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
        var contents = String()
        do {
            contents = try String(contentsOfFile: filePathString!, encoding: String.Encoding.utf8)
            return contents
        } catch let error as NSError {
            print("读取文件异常：\(error.localizedDescription)")
        }
        
        if contents.isEmpty {
            do {
                contents = try String(contentsOfFile: filePathString!, encoding: String.Encoding.GBK)
                return contents
            } catch let error as NSError {
                print("读取文件异常：\(error.localizedDescription)")
            }
        }
        
        if contents.isEmpty {
            do {
                contents = try String(contentsOfFile: filePathString!, encoding: String.Encoding.GB18030)
                return contents
            } catch let error as NSError {
                print("读取文件异常：\(error.localizedDescription)")
            }
        }
        
        return ""
    }
    
    /**
     内容分页
     
     - parameter string: 内容
     
     - parameter rect: 范围
     
     - parameter attrs: 文字属性
     
     - returns: 每一页的起始位置数组
     */
    class func ParserPageRange(string:String, rect:CGRect, attrs:[NSAttributedString.Key:Any]?) ->[BookContents] {
        
        // 记录
        var rangeArray:[BookContents] = []
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: string, attributes: attrs)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            var rangeStruct = BookContents()
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeStruct.range = NSRange(location: rangeOffset, length: range.length)
            rangeStruct.contents = string.cz_subString(range: rangeStruct.range)
            
            rangeArray.append(rangeStruct)
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        return rangeArray
    }
    
    
    /// 配置分页内容
    ///
    /// - Parameters:
    ///   - chapters: 章节内容
    ///   - completion: 回调方法
    func loadChapterModel(_ chapters : String, completion : @escaping ([BookContentModel]) -> Void) {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        paragraphStyle.paragraphSpacing = CGFloat(lineSpacing)
        paragraphStyle.firstLineHeadIndent = CGFloat(lineSpacing) * 2 // 首行缩进
        let fontAttributes = UIFont(name: fontName, size: CGFloat(font))
        
        let contentRanges = BookPageParseManager.ParserPageRange(string: chapters,
                                                                 rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - CGFloat(navHeight)),
                                                                 attrs: [NSAttributedString.Key.font : fontAttributes!,
                                                                         NSAttributedString.Key.foregroundColor : UIColor.CodeColor(color),
                                                                         NSAttributedString.Key.paragraphStyle : paragraphStyle])
        var contentsModels = [BookContentModel]()
        for (index, contentStruct) in contentRanges.enumerated() {
            let contentModel = BookContentModel()
            contentModel.content = chapters.cz_subString(range: contentStruct.range)
            contentModel.characterSort = index
            contentModel.location = contentStruct.range.location
            
            if index == 0 {
                contentModel.firstPage = true
            }
            
            if index == contentRanges.count - 1 {
                contentModel.lastPage = true
            }
            
            contentsModels.append(contentModel)
        }
        
        completion(contentsModels)
    }
    
    /// 加载本地文件内容
    ///
    /// - Parameters:
    ///   - bookName: 文件名称
    ///   - completion: 完成回调
    class func loadBookInfo(_ bookName : String?, completion : @escaping (BookInfoModel?) -> Void) {
        
        if bookName == nil {
            completion(nil)
            return
        }
        
        var contents = loadLocalFile(bookName)
        contents.cz_replaceString(replacedCharacter: "\r", newCharacter: "")
        
        print("内容字数：\(contents.count)")
        
        if contents.count == 0 {
            completion(nil)
            return
        }
        
        let unit = 100_000.0
        
        let ceilUnit = Int(ceil(Double(contents.count) / unit))
        
        var chapterModels = [BookChapterModel]()
        
        let currentTimeStamp = Date.currentTimeStamp
//        let semphore = DispatchSemaphore(value: 1)

        DispatchQueue.groupQueue(progress: { (queue, group) in
            for i in 0..<ceilUnit {
                group.enter()
//                semphore.wait()
                queue.async(group: group, qos: .default, flags: .inheritQoS) {
                    // 截取字符串
                    let childString = contents.cz_subString(range: NSRange(location: i * Int(unit), length: Int(unit)))

                    let regularStrings = childString.filterInRegularExpression("第[0-9|一|二|三|四|五|六|七|八|九|十|零|百|千|万]+[节|篇|卷|部|章].*")
                    
                    let firstDic : [String : Any] = regularStrings!.first!
                    
                    var lastLocation = firstDic["location"] as! Int
                    
                    for index in 1...regularStrings!.count {
                        let chapterModel = BookChapterModel()
                        let lastLocationDic = regularStrings![index - 1] as Dictionary
                        chapterModel.firstCharacter = lastLocation + i * Int(unit)
                        chapterModel.chapterTitle = lastLocationDic["contents"] as? String
                        
                        if index != regularStrings!.count {
                            let locationDic = regularStrings![index] as Dictionary
                            let lastCharacter = locationDic["location"] as! Int
                            
                            chapterModel.lastCharacter = lastCharacter + i * Int(unit)
                            
                            let distance = lastLocation.distance(to: lastCharacter)
                            
                            chapterModel.contents = childString.cz_subString(range: NSRange(location: lastLocation, length: distance))
                            chapterModel.canCutting = true
                            
                            lastLocation = lastCharacter
                        }
                        chapterModels.append(chapterModel)
                    }
//                    semphore.signal()
                    group.leave()
                }
            }
        }) {
            let nowTimeStamp = Date.currentTimeStamp
            chapterModels.sort(by: { (lastModel, currentModel) -> Bool in
                if lastModel.firstCharacter > currentModel.firstCharacter {
                    return false
                }
                
                return true
            })
            
            for (index, model) in chapterModels.enumerated() {
                model.sort = index + 1
                
                if index == 0 {
                    model.firstChapter = true
                }
                
                if index == (chapterModels.count - 1) {
                    model.lastChapter = true
                }
                
                if model.canCutting {
                    break
                }
                
                model.canCutting = true
                
                if index == (chapterModels.count - 1) {
                    model.contents = contents.cz_subString(range: NSRange(location: model.firstCharacter, length: contents.count - model.firstCharacter))
                    model.lastCharacter = contents.count
                }else {
                    let nextModel = chapterModels[index + 1]
                    model.contents = contents.cz_subString(range: NSRange(location: model.firstCharacter, length: nextModel.firstCharacter - model.firstCharacter))
                    model.lastCharacter = nextModel.firstCharacter
                }
            }
            
            let firstModel = chapterModels.first!
            
            if firstModel.firstCharacter != 0 {
                firstModel.firstChapter = false
                let beginModel = BookChapterModel()
                beginModel.contents = contents.cz_subString(range: NSRange(location: 0, length: firstModel.firstCharacter))
                beginModel.firstCharacter = 0
                beginModel.lastCharacter = firstModel.firstCharacter
                beginModel.canCutting = true
                beginModel.sort = 0
                beginModel.chapterTitle = "开始"
                beginModel.firstChapter = true
                chapterModels.insert(beginModel, at: 0)
            }
            

            print("时间：\(nowTimeStamp - currentTimeStamp)")
            let bookInfo = BookInfoModel.init()
            bookInfo.bookId = "gzr"
            bookInfo.bookName = bookName!
            bookInfo.location = 0
            bookInfo.chapterList = chapterModels
            
            completion(bookInfo)
        }
    }
    
    
    // MARK: - 协议实现
    @discardableResult
    func save() -> Bool {
        let instance = instanceForPrimaryKey(1)
        
        if instance != nil {
            let udpateSql = DataBaseManager.updateSqlString(table: "BookStyle", columns: "font = \(font), fontName = '\(fontName)', lineSpacing = \(lineSpacing), color = '\(color)', styleType = \(contentType.rawValue)", parameters: "styleId = 1")
            
            return DataBaseManager.sharedInstance.excuteSql(udpateSql)
        }
        let insertSql = DataBaseManager.insertSqlString(table: "BookStyle", columns: "font, fontName, lineSpacing, color, styleType", values: "\(font), '\(fontName)', \(lineSpacing), '\(color)', \(contentType.rawValue)")
        
        return DataBaseManager.sharedInstance.excuteSql(insertSql)
    }
    
    func instanceForPrimaryKey(_ primaryKey: Any) -> Any? {
        let selectSql = DataBaseManager.querySqlString(table: "BookStyle", columns: nil, parameters: "styleId = \(primaryKey)")
        
        return modelsWithSql(selectSql)?.first
    }
    
    func modelsWithSql(_ sql: String) -> Array<Any>? {
        return DataBaseManager.sharedInstance.querySql(sql)
    }
}
