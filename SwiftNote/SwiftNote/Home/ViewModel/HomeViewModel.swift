//
//  HomeViewModel.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

/// 首页页面标识符
///
/// - none: 无
/// - iBook: 电子书
/// - news: 新闻
enum HomePage {
    case none
    case iBook
    case news
}

/// 首页ViewModel
class HomeViewModel: NSObject {
    var model : HomeModel!
    /// 打开的视图类型
    var homeUri : HomePage!
    
    
    override init() {
        
        super.init()
    }

    class func configureHomeDataSource() -> Array<HomeViewModel> {
        var modelArray = [HomeViewModel]()
        let titleArray = ["电子书", "新闻"]
        let pageArray = [HomePage.iBook, HomePage.news]
        
        for i in 0..<titleArray.count {
            let tmpViewModel = HomeViewModel.init()
            let homeModel = HomeModel.init()
            homeModel.homeTitle = titleArray[i]
            tmpViewModel.homeUri = pageArray[i]
            tmpViewModel.model = homeModel
            modelArray.append(tmpViewModel)
        }
        
        return modelArray
    }
}
