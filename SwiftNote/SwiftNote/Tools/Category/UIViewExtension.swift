//
//  UIViewExtension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/11/30.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import Foundation
import UIKit

/// 渐变图层的渐变方向
///
/// - topLeftToBottomRight: 左上到右下
/// - bottomLeftToTopRight: 左下到右上
/// - horizontal: 水平渐变
/// - vertical: 垂直渐变
enum GradientLayerDirection {
    case topLeftToBottomRight
    case bottomLeftToTopRight
    case horizontal
    case vertical
}

extension UIView {
    
    /// 获取外坐标
    var qnOrigin : CGPoint {
        get { return self.frame.origin }
    }
    
    /// 获取视图尺寸
    var qnSize : CGSize {
        get { return self.bounds.size }
    }
    
    /// 视图外坐标x
    var qnOriginX : CGFloat {
        get { return self.qnOrigin.x }
    }
    
    /// 视图最大x坐标
    var qnMaxOriginX : CGFloat {
        get { return self.qnOrigin.x + self.qnBoundsWidth }
    }
    
    /// 视图外坐标y
    var qnOriginY : CGFloat {
        get { return self.qnOrigin.y }
    }
    
    /// 视图最大y坐标
    var qnMaxOriginY : CGFloat {
        get { return self.qnOriginY + self.qnBoundsHeight }
    }
    
    /// 视图宽度
    var qnBoundsWidth : CGFloat {
        get { return self.qnSize.width }
    }
    
    /// 视图高度
    var qnBoundsHeight : CGFloat {
        get { return self.qnSize.height }
    }
    
    /// 内坐标
    var qnBoundsOrigin : CGPoint {
        get { return self.bounds.origin }
    }
    
    
    
    /// 添加圆角
    ///
    /// - Parameters:
    ///   - corner: 需要添加圆角的方向
    ///   - radius: 圆角角度
    /// - Returns: 圆角
    func qn_addRoundCorner(corner:UIRectCorner, radius:CGFloat)->CAShapeLayer {
        let maskLayer = CAShapeLayer.init()
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        return maskLayer
    }
    
    // MARK: - subLayer 子图层
    /// 添加子图层
    ///
    /// - Parameters:
    ///   - color: 图层颜色
    ///   - corner: 圆角的方向
    ///   - rect: 图层尺寸
    ///   - radius: 圆角角度
    /// - Returns: 子图层
    func qn_addSubLayer(color : UIColor, corner : UIRectCorner, rect : CGRect, radius : CGFloat) -> CALayer {
        let subLayer = CAShapeLayer.init()
        let layerPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        
        subLayer.path = layerPath.cgPath
        subLayer.fillColor = color.cgColor
        self.layer.insertSublayer(subLayer, at: 0)
        
        return subLayer
    }
    
    /// 添加子图层
    ///
    /// - Parameters:
    ///   - color: 图层颜色
    ///   - corner: 圆角的方向
    ///   - radius: 圆角角度
    /// - Returns: 子图层
    func qn_addSubLayer(color : UIColor, corner : UIRectCorner, radius : CGFloat) -> CALayer {
        return qn_addSubLayer(color: color, corner: corner, rect: self.bounds, radius: radius)
    }
    
    // MARK: - gradientLayer 渐变
    
    /// 添加渐变图层
    ///
    /// - Parameters:
    ///   - rect: 渐变图层尺寸
    ///   - colors: 渐变颜色范围
    ///   - points: 渐变方向
    ///   - locations: 渐变程度坐标
    ///   - corner: 圆角的方向
    ///   - radius: 圆角角度
    /// - Returns: 渐变图层
    func qn_addGradientLayer(rect:CGRect, colors : Array<UIColor>, points : Array<NSValue>, locations : Array<NSNumber>, corner : UIRectCorner, radius : CGFloat) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer.init()
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        if (points.first?.isKind(of: NSValue.self))! {
            startPoint = (points.first?.cgPointValue)!
        }
        
        if (points.last?.isKind(of: NSValue.self))! {
            endPoint = (points.last?.cgPointValue)!
        }
        
        var cgColors = Array<CGColor>()
        
        for color in colors {
            cgColors.append(color.cgColor)
        }
        
        gradientLayer.locations = locations
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = radius
        gradientLayer.frame = rect
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
    
    /// 添加渐变图层
    ///
    /// - Parameters:
    ///   - rect: 渐变图层尺寸
    ///   - colors: 渐变颜色范围
    ///   - gradientDirection: 渐变方向
    ///   - locations: 渐变程度坐标
    ///   - corner: 圆角的方向
    ///   - radius: 圆角角度
    /// - Returns: 渐变图层
    func qn_addGradientLayer(rect:CGRect, colors : Array<UIColor>, gradientDirection : GradientLayerDirection, locations : Array<NSNumber>, corner : UIRectCorner, radius : CGFloat) -> CAGradientLayer {
        
        var points = Array<NSValue>()
        switch gradientDirection {
        case .topLeftToBottomRight:
            points = [NSValue(cgPoint: CGPoint(x: 0, y: 0)), NSValue(cgPoint: CGPoint(x: 1, y: 1))]
            break
        case .bottomLeftToTopRight:
            points = [NSValue(cgPoint: CGPoint(x: 0, y: 1)), NSValue(cgPoint: CGPoint(x: 1, y: 0))]
            break
        case .vertical:
            points = [NSValue(cgPoint: CGPoint(x: 0, y: 0)), NSValue(cgPoint: CGPoint(x: 0, y: 1))]
            break
        case .horizontal:
            points = [NSValue(cgPoint: CGPoint(x: 0, y: 0)), NSValue(cgPoint: CGPoint(x: 1, y: 0))]
            break
        }
        
        return qn_addGradientLayer(rect: rect, colors: colors, points: points, locations: locations, corner: corner, radius: radius)
    }
    
    /// 添加渐变图层
    ///
    /// - Parameters:
    ///   - rect: 渐变图层尺寸
    ///   - colors: 渐变颜色范围
    ///   - gradientDirection: 渐变方向
    ///   - radius: 圆角角度
    /// - Returns: 渐变图层
    func qn_addGradientLayer(rect:CGRect, colors : Array<UIColor>, gradientDirection : GradientLayerDirection, radius : CGFloat) -> CAGradientLayer {
        return qn_addGradientLayer(rect: rect, colors: colors, gradientDirection: gradientDirection, locations: [NSNumber(value: 0), NSNumber(value: 1)], corner: .allCorners, radius: radius)
    }
    
    /// 添加渐变图层
    ///
    /// - Parameters:
    ///   - colors: 渐变颜色范围
    ///   - gradientDirection: 渐变方向
    ///   - radius: 圆角角度
    /// - Returns: 渐变图层
    func qn_addGradientLayer(colors : Array<UIColor>, gradientDirection : GradientLayerDirection, radius : CGFloat) -> CAGradientLayer {
        return qn_addGradientLayer(rect: self.bounds, colors: colors, gradientDirection: gradientDirection, locations: [NSNumber(value: 0), NSNumber(value: 1)], corner: .allCorners, radius: radius)
    }
    
    
    // MARK: - 阴影图层
    /// 添加阴影图层
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - shadowRect: 阴影尺寸
    ///   - radius: 阴影圆角
    /// - Returns: 阴影图层
    func qn_addShadowLayer(color : UIColor, shadowRect : CGRect, radius : CGFloat) -> CAShapeLayer {
        let shadowLayer = CAShapeLayer.init()
        shadowLayer.frame = self.bounds
        shadowLayer.shadowRadius = radius
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.opacity = 1
        
        let shadowPath = UIBezierPath(roundedRect: shadowRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        shadowLayer.path = shadowPath.cgPath
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        
        return shadowLayer
    }
}
