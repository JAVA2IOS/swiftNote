//
//  ViewControllerExtension.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/13.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewController 扩展方法
extension UIViewController {
    /// 推进视图
    ///
    /// - Parameter controllerName: 子视图控制器名称
    func pushChildController(controllerName : String) -> Void {
        if self.navigationController != nil {
            let childVCClass = NSClassFromString(controllerName) as! UIViewController.Type
            let childVC = childVCClass.init()
            childVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(childVC, animated: true)
        }
    }
}
