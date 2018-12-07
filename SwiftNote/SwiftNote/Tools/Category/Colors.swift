//
//  Colors.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/14.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import Foundation
import UIKit

private extension String {
    mutating func removeHashIfNecessary() {
        if hasPrefix("#") {
            self = replacingOccurrences(of: "#", with: "")
        }
        if hasPrefix("0x") {
            self = replacingOccurrences(of: "0x", with: "")
        }
    }
}

extension UIColor {
    /// 导航栏配色
    ///
    /// - Returns: 白色
    class func NavigationBackgroundColor() -> UIColor {
        return UIColor.CodeColor("ffffff")
    }
    
    /// tabbar背景配色
    ///
    /// - Returns: 白色
    class func TabBarBackgroundColor() -> UIColor {
        return UIColor.CodeColor("ffffff")
    }
    
    /// tabbarItem选中配色
    ///
    /// - Returns: 蓝色61A5FA
    class func TabBarItemSelectColor() -> UIColor {
        return UIColor.CodeColor("61A5FA")
    }
    
    /// tabbarItem未选中配色
    ///
    /// - Returns: 灰色686868
    class func TabBarItemUnselectColor() -> UIColor {
        return UIColor.CodeColor("686868")
    }
    
    /// 导航栏图标颜色
    ///
    /// - Returns: 纯黑色
    class func NavgationIconColor() -> UIColor {
        return UIColor.black
    }
    
    /// 文本标题颜色
    ///
    /// - Returns: 亮灰色878D94
    class func titleColor() -> UIColor {
        return deepGrayColor()
    }
    
    /// 文本内容颜色
    ///
    /// - Returns: 淡灰色F5F5F5
    class func titleContentColor() -> UIColor {
        return lightGrayColor()
    }
    
    /// 亮灰色
    ///
    /// - Returns: 亮灰色878D94
    class func deepGrayColor() -> UIColor {
        return UIColor.CodeColor("878D94")
    }
    
    /// 淡灰色
    ///
    /// - Returns: 淡灰色F5F5F5
    class func lightGrayColor() -> UIColor {
        return UIColor.CodeColor("F5F5F5")
    }
    
    /// 随机颜色
    open class var randomColor : UIColor {
        get
        {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    class func CodeColor(_ color : String) -> UIColor {
        var colorStr = color
        if colorStr.isEmpty {
            return UIColor.clear
        }
        
        colorStr.removeHashIfNecessary()
        let s = colorStr.cString(using: String.Encoding.ascii)
        let value = strtoll(s, nil, 16)
        var r : Int = 0, g : Int = 0, b : Int = 0, a : Int = 0
        switch strlen(s) {
        case 2:
            r = Int(value)
            g = Int(value)
            b = Int(value)
            a = 255
            break
        case 3:
            r = Int(((value & 0xf00) >> 8))
            g = Int(((value & 0x0f0) >> 4));
            b = Int(((value & 0x00f) >> 0))
            r = r * 16 + r
            g = g * 16 + g
            b = b * 16 + b
            a = 255
            break
        case 6:
            r = Int((value & 0xff0000) >> 16)
            g = Int((value & 0x00ff00) >>  8)
            b = Int((value & 0x0000ff) >>  0)
            a = 255
            break
        default:
            r = Int((value & 0xff000000) >> 24)
            g = Int((value & 0x00ff0000) >> 16)
            b = Int((value & 0x0000ff00) >>  8)
            a = Int((value & 0x000000ff) >>  0)
            break
        }
        return UIColor.init(red: CGFloat(Float(r) / 255.0), green: CGFloat(Float(g) / 255.0), blue: CGFloat(Float(b) / 255.0), alpha: CGFloat(Float(a) / 255.0))
    }
}

