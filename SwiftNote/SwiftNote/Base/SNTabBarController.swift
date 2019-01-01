//
//  SNTabBarController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/13.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import UIKit

let HomeImage = "tab_consume_unselect"
let HomeSelectImage = "tab_consume_select"
let MeImage = "tab_me_unselect"
let MeSelectImage = "tab_me_select"


class SNTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNav = self.configureChildViewController(controllerName: NSStringFromClass(HomeViewController.self), tabBarTitle: "首页")
        let meNav = self.configureChildViewController(controllerName: NSStringFromClass(MeViewController.self), tabBarTitle: "我的")
        self.viewControllers = [homeNav, meNav]
        homeNav.tabBarItem = UITabBarItem.init(title: "首页", image: UIImage.init(named: HomeImage), selectedImage: UIImage(named: HomeSelectImage))
        meNav.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage.init(named: MeImage), selectedImage: UIImage(named: MeSelectImage))
        
        self.tabBar.backgroundColor = UIColor.TabBarBackgroundColor()
        self.tabBar.shadowImage = UIImage.init()
        self.tabBar.backgroundImage = UIImage.init()
        self.tabBar.tintColor = UIColor.TabBarItemSelectColor()
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.TabBarItemUnselectColor()
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// 配置tabBar的基本子视图控制器
    ///
    /// - Parameters:
    ///   - controllerName: 控制器类名
    ///   - tabBarTitle: 名称
    /// - Returns: 视图控制器实例对象
    private func configureChildViewController(controllerName : String, tabBarTitle : String) -> UINavigationController {
        let rootVC = NSClassFromString(controllerName) as! UIViewController.Type
        let childVc : UIViewController = rootVC.init()
        childVc.title = tabBarTitle
        let navigationVC = UINavigationController.init(rootViewController: childVc)
        navigationVC.navigationBar.tintColor = UIColor.titleColor()
        
        return navigationVC
    }
}
