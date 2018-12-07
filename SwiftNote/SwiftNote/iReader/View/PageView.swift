//
//  PageView.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/6.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

/// 移动的方向
///
/// - forward: 向前滑动
/// - backward: 向后滑动
enum movedDirection {
    case forward
    case backward
}

protocol PageViewDataSource {
    func pageViewDataSourceTurnNextPage() -> BookContentModel?

    func pageViewDataSourceTurnPreviousPage() -> BookContentModel?
}


class PageView: UIView {
    /// 滑动手势
    //    private var panGesture : UIPanGestureRecognizer?
    /// 截图
    private var screenShotView : UIImageView!
    
    private var currentScreenShotImage : UIImage!
    
    private var lastScreenShotImage : UIImage!
    
    private var contentView : UILabel!
    
    private var lastContentView : UILabel!
    
    private var attributesDic : Dictionary<String, Any>!
    
    var contentModel : BookContentModel?
    
    var pageDelegate : PageViewDataSource!
    
    private var initStatus = false
    
    private var changeStatus = false
    
    private var direction : movedDirection = .forward
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UILabel(frame: CGRect(x: 10, y: 10, width: self.bounds.size.width - 20, height: self.bounds.size.height - 20))
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.textColor = .red
        contentView.textAlignment = .justified
        contentView.lineBreakMode = .byWordWrapping
        contentView.numberOfLines = 0
        
        self.addSubview(contentView)
        
        screenShotView = UIImageView(frame: self.bounds)
        self.addSubview(screenShotView)
        self.bringSubviewToFront(screenShotView)
        screenShotView.alpha = 0
        
    }
    
    private func getTextContent(_ bookModel : BookContentModel) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.firstLineHeadIndent = 40 // 首行缩进
        
        if (bookModel == nil) {
            return NSMutableAttributedString(string: "")
        }
        let attributedString = NSMutableAttributedString(string: bookModel.content!)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.string.count))
        
        return attributedString
    }
    
    func configureContent() {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.firstLineHeadIndent = 40 // 首行缩进
        
        if (contentModel == nil) {
            return
        }
        let attributedString = NSMutableAttributedString(string: contentModel!.content!)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.string.count))
        
        contentView.attributedText = attributedString
    }
    
    @objc func panHandler(_ pan : UIPanGestureRecognizer) {
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 截屏
    func contentScreenShot() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        currentScreenShotImage = image
        
        self.bringSubviewToFront(screenShotView)
        screenShotView.layer.shadowColor = UIColor.lightGray.cgColor
        screenShotView.layer.shadowOpacity = 1
    }
    
    
    /// 配置数据源
    private func configureDataSource() {
        if direction == .forward {
            contentModel = pageDelegate.pageViewDataSourceTurnNextPage()
            configureContent()
        }else {
            contentModel = pageDelegate.pageViewDataSourceTurnPreviousPage()!
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeStatus = false
        initStatus = false
        direction = .forward
        contentScreenShot()
        screenShotView.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        let lastPoint = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        
        if !initStatus {
            initStatus = true
            if (lastPoint.x - currentPoint.x) < 0 {
                direction = .backward
                screenShotView.frame = CGRect(x: -screenShotView.frame.size.width, y: 0, width: screenShotView.frame.size.width, height: screenShotView.frame.size.height)
                if lastScreenShotImage != nil {
                    screenShotView.image = lastScreenShotImage
                }
            }else {
                direction = .forward
                screenShotView.image = currentScreenShotImage
            }
            
            configureDataSource()
        }
        
        let distance = currentPoint.x - lastPoint.x
        let currentOffsetX =  screenShotView.frame.origin.x + distance
        
        screenShotView.frame = CGRect(x: currentOffsetX, y: 0, width: screenShotView.frame.size.width, height: screenShotView.frame.size.height)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        let currentPoint = touch.location(in: self)
        initStatus = false
        UIView.animate(withDuration: 0.3, animations: {
            if self.direction == .backward {
                if currentPoint.x > (self.frame.size.width / 2) {
                    self.screenShotView.frame = self.bounds
                    self.changeStatus = true
                }else {
                    self.changeStatus = false
                    self.screenShotView.frame = CGRect(x: -self.screenShotView.frame.size.width, y: 0, width: self.screenShotView.frame.size.width, height: self.screenShotView.frame.size.height)
                }
            }else {
                if (self.frame.size.width - currentPoint.x) > (self.frame.size.width / 2) {
                    self.changeStatus = true
                    self.screenShotView.frame = CGRect(x: -self.screenShotView.frame.size.width, y: 0, width: self.screenShotView.frame.size.width, height: self.screenShotView.frame.size.height)
                }else {
                    self.screenShotView.frame = self.bounds
                    self.changeStatus = false
                }
            }
        }, completion: { (Bool) in
            if self.direction == .backward {
                if self.changeStatus {
                    self.configureContent()
                }
            }
            
            self.screenShotView.alpha = 0
            self.sendSubviewToBack(self.screenShotView)
            self.screenShotView.frame = self.bounds
            self.direction = .forward
            
            self.lastScreenShotImage = self.screenShotView.image
        })
    }
}
