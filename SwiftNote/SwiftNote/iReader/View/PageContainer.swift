//
//  PageContainer.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/11.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

/// 页面内容容器
class PageContainer: UIView {
    
    var pragraphContents : String?
    
    var currentPageModel : BookContentModel? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1
        let context = UIGraphicsGetCurrentContext()
        
        // 2
        context?.textMatrix = .identity
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 3
        let path = CGMutablePath()
        path.addRect(CGRect(x: 10, y: 10, width: self.qnBoundsWidth - 20, height: self.qnBoundsHeight - 20))
        
        // 4
        let attrString = getTextContent(currentPageModel)
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        
        // 5
        CTFrameDraw(frame,context!)
    }

    /// 配置文本内容
    ///
    /// - Parameter bookModel: 文本内容模型对象
    /// - Returns: 内容文本
    private func getTextContent(_ bookModel : BookContentModel?) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.firstLineHeadIndent = 40 // 首行缩进
        
        if bookModel == nil {
            return NSMutableAttributedString(string: "")
        }
        
        let attributedString = NSMutableAttributedString(string: bookModel!.content)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.string.count))
        
        return attributedString
    }
}
