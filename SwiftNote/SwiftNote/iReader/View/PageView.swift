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
/// - forward: 下一页
/// - backward: 上一页
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
    
    var currentContentModel : BookContentModel?
    
    var pageDelegate : PageViewDataSource? {
        didSet {
            configureDataSource()
        }
    }
    
    private var lastContentModel : BookContentModel?
    
    private var nextContentModel : BookContentModel?
    
    private var initStatus = false
    
    private var changeStatus = false
    
    private var direction : movedDirection = .forward
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加子视图
        configureSubViews()
        
        // 添加数据
//        configureDataSource()
    }
    
    /// 配置子视图
    private func configureSubViews() {
        contentView = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 0, height: self.bounds.size.height - 0))
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.textColor = .red
        contentView.textAlignment = .justified
        contentView.lineBreakMode = .byWordWrapping
        contentView.numberOfLines = 0
        contentView.backgroundColor = .red
        
        self.addSubview(contentView)
        
        lastContentView = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 0, height: self.bounds.size.height - 0))
        lastContentView.font = UIFont.systemFont(ofSize: 15)
        lastContentView.textColor = .red
        lastContentView.textAlignment = .justified
        lastContentView.lineBreakMode = .byWordWrapping
        lastContentView.numberOfLines = 0
        lastContentView.alpha = 0
        lastContentView.backgroundColor = .yellow
        
        self.addSubview(lastContentView)
        
        self.bringSubviewToFront(self.contentView)
    }
    
    
    /// 配置文本内容
    ///
    /// - Parameter bookModel: 文本内容模型对象
    /// - Returns: 内容文本
    private func getTextContent(_ bookModel : BookContentModel) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.firstLineHeadIndent = 40 // 首行缩进
        
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
        
        if (currentContentModel == nil) {
            return
        }
        let attributedString = NSMutableAttributedString(string: currentContentModel!.content!)
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
        lastContentModel = pageDelegate?.pageViewDataSourceTurnPreviousPage() ?? nil
        nextContentModel = pageDelegate?.pageViewDataSourceTurnNextPage() ?? nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeStatus = false
        initStatus = false
        direction = .forward
        lastContentView.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        let lastPoint = touch.previousLocation(in: self)
        let currentPoint = touch.location(in: self)
        
        if !initStatus {
            initStatus = true
            if (lastPoint.x - currentPoint.x) < 0 {
                direction = .backward
                if lastContentModel == nil {
                    return
                }
                // 配置上一页数据
                lastContentView.frame = CGRect(x: -lastContentView.frame.size.width, y: 0, width: lastContentView.frame.size.width, height: lastContentView.frame.size.height)
                self.bringSubviewToFront(lastContentView)
            }else {
                direction = .forward
            }
        }
        
        let distance = currentPoint.x - lastPoint.x
        
        if direction == .forward {
            if nextContentModel == nil {
                return
            }
            let currentOffsetX = contentView.qnOriginX + distance
            contentView.frame = CGRect(x: currentOffsetX, y: contentView.qnOriginY, width: contentView.qnBoundsWidth, height: contentView.qnBoundsHeight)
        }else {
            if lastContentModel == nil {
                return
            }
            let currentOffsetX = lastContentView.qnOriginX + distance
            lastContentView.frame = CGRect(x: currentOffsetX, y: lastContentView.qnOriginY, width: lastContentView.qnBoundsWidth, height: lastContentView.qnBoundsHeight)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        initStatus = false
        UIView.animate(withDuration: 0.3, animations: {
            if self.direction == .backward {
                if self.lastContentModel == nil {
                    return
                }
                if abs(0 - self.lastContentView.qnOriginX) < (self.frame.size.width / 2) {
                    self.lastContentView.frame = self.bounds
                    self.changeStatus = true
                }else {
                    self.changeStatus = false
                    self.lastContentView.frame = CGRect(x: -self.lastContentView.qnBoundsWidth, y: self.lastContentView.qnOriginY, width: self.lastContentView.qnBoundsWidth, height: self.lastContentView.qnBoundsHeight)
                }
            }else {
                if self.nextContentModel == nil {
                    return
                }
                if abs(0 - self.contentView.qnOriginX) > (self.frame.size.width / 2) {
                    self.changeStatus = true
                    self.contentView.frame = CGRect(x: -self.contentView.qnBoundsWidth, y: self.contentView.qnOriginY, width: self.contentView.qnBoundsWidth, height: self.contentView.qnBoundsHeight)
                }else {
                    self.contentView.frame = self.bounds
                    self.changeStatus = false
                }
            }
        }, completion: { (Bool) in
            if self.changeStatus {
                if self.direction == .backward {
                    if self.lastContentModel == nil {
                        return
                    }
                    self.currentContentModel = self.lastContentModel
                    self.configureDataSource()
                }else {
                    if self.nextContentModel == nil {
                        return
                    }
                    self.currentContentModel = self.nextContentModel
                    self.configureDataSource()
                }
            }
            
            self.lastContentView.alpha = 0
            self.lastContentView.frame = self.bounds
            self.contentView.frame = self.bounds
            self.bringSubviewToFront(self.contentView)
            self.direction = .forward
        })
    }
}
