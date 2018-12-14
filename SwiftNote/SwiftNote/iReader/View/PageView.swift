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

/// 数据源配置
@objc protocol PageViewDataSource : NSObjectProtocol {
    
    /// 配置上一页的数据
    ///
    /// - Parameter currentModel: 当前页面的数据配置
    /// - Returns: 上一页数据配置，如果上一页数据为空，返回nil
    func pageViewDataSourceTurnNextPage(_ currentModel : BookContentModel?) -> BookContentModel?

    /// 配置下一页的数据
    ///
    /// - Parameter currentModel: 当前页面的数据
    /// - Returns: 下一页的数据配置，如果下一页数据为空，返回nil
    func pageViewDataSourceTurnPreviousPage(_ currentModel : BookContentModel?) -> BookContentModel?
    
    /// 设置当前页面的数据源
    ///
    /// - Parameters:
    ///   - currentPageView: 当前的视图容器
    ///   - dataModel: 当前的数据
    /// - Returns: 回调方法
    func pageViewDataSourceConfigureData(_ currentPageView : UIView, dataModel : BookContentModel?)
    
    /// 加载完成后
    ///
    /// - Parameter _completion: 是否完成了跳转，如果取消了跳转返回false
    /// - Returns: 回调方法
    @objc optional func pageViewDataSourceTransferCompletion(_ completion : Bool) -> Void
}


class PageView: UIView {
    /// 当前数据视图
    private var currentContentView : UIView!
    
    /// 第二层数据视图用于滑动切换使用
    private var lastContentView : UIView!
    
    /// 数据样式
    private var attributesDic : Dictionary<String, Any>!
    
    /// 滑动翻页判定的有效距离
    private var scrollDistance = 0.0
    
    /// 当前数据源
    var currentContentModel : BookContentModel?
    
    /// 是否开启动画效果
    var animated = true
    
    /// 数据源委托对象
    weak var pageDelegate : PageViewDataSource? {
        didSet {
            configureDataSource()
        }
    }
    
    /// 上一个页面的数据源
    private var lastContentModel : BookContentModel?
    
    /// 滑动到下一页的数据源
    private var nextContentModel : BookContentModel?
    
    /// 滚动方向锁定标识符，true锁定了滑动方向，再滑动途中后不再更改方向
    private var initStatus = false
    
    /// 是否完成了滑动，如果滑动取消了，则未完成
    private var changeStatus = false
    
    /// 动画是否完成，动画未完成时无法再次滑动页面
    private var animatedStatus = false
    
    /// 滑动的方向，默认下一页，每次滑动完成后恢复该方向
    private var direction : movedDirection = .forward
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollDistance = Double(self.qnBoundsWidth / 4)
        
        // 添加子视图
        configureSubViews()
    }
    
    
    /// 注册视图容器
    ///
    /// - Parameter registedClassName: 视图容器类名
    func registContainerClass(_ registedClassName : UIView.Type) {
        currentContentView.removeFromSuperview()
        lastContentView.removeFromSuperview()
        
        currentContentView = registedClassName.init()
        lastContentView = registedClassName.init()
        
        configureCurrentPage()
        configureNextPage()
    }
    
    
    /// 添加当前视图
    private func configureCurrentPage() {
        currentContentView.frame = self.bounds
        pageDelegate?.pageViewDataSourceConfigureData(currentContentView, dataModel: currentContentModel)
        
        if self.subviews.contains(currentContentView) {
            return
        }
        self.addSubview(currentContentView)
        
    }
    
    /// 添加下一个视图
    private func configureNextPage() {
        lastContentView.frame = self.bounds
        if self.subviews.contains(lastContentView) {
            return
        }
        self.addSubview(lastContentView)
    }
    
    /// 配置子视图
    private func configureSubViews() {
        currentContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 0, height: self.bounds.size.height - 0))
        currentContentView.backgroundColor = UIColor.CodeColor("#F5DEB3")
        
        self.addSubview(currentContentView)
        
        lastContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 0, height: self.bounds.size.height - 0))
        lastContentView.backgroundColor = UIColor.CodeColor("#F4A460")
        
        self.addSubview(lastContentView)
        
        self.bringSubviewToFront(self.currentContentView)
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
        
        let attributedString = NSMutableAttributedString(string: bookModel!.content!)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.string.count))
        
        return attributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 截屏
    private func contentScreenShot() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    /// 配置数据源
    private func configureDataSource() {
        configurePreviousPageData()
        configureNextPageData()
    }
    
    /// 配置下一页数据
    private func configureNextPageData() {
        nextContentModel = pageDelegate?.pageViewDataSourceTurnNextPage(currentContentModel) ?? nil
    }
    
    /// 配置上一页数据
    private func configurePreviousPageData() {
        lastContentModel = pageDelegate?.pageViewDataSourceTurnPreviousPage(currentContentModel) ?? nil
    }
    
    /// 页面是否可以改变
    ///
    /// - Returns: 默认false未改变
    private func pageDidChanged() -> Bool {
        if direction == .forward {
            if nextContentModel != nil {
                return true
            }
        }else {
            if lastContentModel != nil {
                return true
            }
        }
        
        return false
    }
    
    /// 给视图添加阴影
    ///
    /// - Parameter neededShadowView: 需要添加阴影的视图
    private func pageDrawShadow(_ neededShadowView : UIView) {
        neededShadowView.layer.shadowColor = UIColor.CodeColor("696969").cgColor
        neededShadowView.layer.shadowOffset = CGSize(width: 8, height: 0)
        neededShadowView.layer.shadowRadius = 4
        neededShadowView.layer.shadowOpacity = 0.3
    }
    
    
    // MARK: - 滑动监听
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if animatedStatus {
            return
        }
        changeStatus = false
        initStatus = false
        direction = .forward
        lastContentView.alpha = 1
        self.bringSubviewToFront(currentContentView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if animatedStatus {
            return
        }

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
                lastContentView.frame = CGRect(x: -lastContentView.frame.size.width, y: lastContentView.qnOriginY, width: lastContentView.frame.size.width, height: lastContentView.frame.size.height)
                self.bringSubviewToFront(lastContentView)
                pageDelegate?.pageViewDataSourceConfigureData(lastContentView, dataModel: lastContentModel)
                pageDrawShadow(lastContentView)
            }else {
                direction = .forward
                pageDelegate?.pageViewDataSourceConfigureData(lastContentView, dataModel: nextContentModel)
                self.bringSubviewToFront(currentContentView)
                pageDrawShadow(currentContentView)
            }
        }
        
        let distance = currentPoint.x - lastPoint.x
        
        if direction == .forward {
            if nextContentModel == nil {
                return
            }
            let currentOffsetX = currentContentView.qnOriginX + distance
            currentContentView.frame = CGRect(x: min(currentOffsetX, 0), y: currentContentView.qnOriginY, width: currentContentView.qnBoundsWidth, height: currentContentView.qnBoundsHeight)
        }else {
            if lastContentModel == nil {
                return
            }
            let currentOffsetX = lastContentView.qnOriginX + distance
            lastContentView.frame = CGRect(x: min(currentOffsetX, 0), y: lastContentView.qnOriginY, width: lastContentView.qnBoundsWidth, height: lastContentView.qnBoundsHeight)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        initStatus = false
        animatedStatus = true
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            if self.direction == .backward {
                if self.lastContentModel == nil {
                    return
                }
                if abs(self.qnBoundsWidth + self.lastContentView.qnOriginX) > CGFloat(self.scrollDistance) {
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
                if abs(0 - self.currentContentView.qnOriginX) > CGFloat(self.scrollDistance) {
                    self.changeStatus = true
                    self.currentContentView.frame = CGRect(x: -self.currentContentView.qnBoundsWidth, y: self.currentContentView.qnOriginY, width: self.currentContentView.qnBoundsWidth, height: self.currentContentView.qnBoundsHeight)
                }else {
                    self.currentContentView.frame = self.bounds
                    self.changeStatus = false
                }
            }
        }, completion: { (Bool) in
            self.animatedStatus = false
            if self.changeStatus {
                if self.direction == .backward {
                    if self.lastContentModel == nil {
                        return
                    }
                    self.nextContentModel = self.currentContentModel
                    self.currentContentModel = self.lastContentModel
                    self.pageDelegate?.pageViewDataSourceConfigureData(self.currentContentView, dataModel: self.currentContentModel)
                    self.configurePreviousPageData()
                    if self.pageDelegate != nil {
                        if self.pageDelegate!.responds(to: #selector(self.pageDelegate?.pageViewDataSourceTransferCompletion(_:))) {
                            self.pageDelegate!.pageViewDataSourceTransferCompletion!(true)
                        }
                    }
                }else {
                    if self.nextContentModel == nil {
                        return
                    }
                    self.lastContentModel = self.currentContentModel
                    self.currentContentModel = self.nextContentModel
                    self.pageDelegate?.pageViewDataSourceConfigureData(self.currentContentView, dataModel: self.currentContentModel)
                    self.configureNextPageData()
                    if self.pageDelegate != nil {
                        if self.pageDelegate!.responds(to: #selector(self.pageDelegate?.pageViewDataSourceTransferCompletion(_:))) {
                            self.pageDelegate!.pageViewDataSourceTransferCompletion!(true)
                        }
                    }
                }
            }else {
                if self.pageDidChanged() {
                    if self.pageDelegate != nil {
                        if self.pageDelegate!.responds(to: #selector(self.pageDelegate?.pageViewDataSourceTransferCompletion(_:))) {
                            self.pageDelegate!.pageViewDataSourceTransferCompletion!(false)
                        }
                    }
                }
            }
            
            self.lastContentView.frame = self.bounds
            self.currentContentView.frame = self.bounds
            self.bringSubviewToFront(self.currentContentView)
            self.direction = .forward
        })
    }
}
