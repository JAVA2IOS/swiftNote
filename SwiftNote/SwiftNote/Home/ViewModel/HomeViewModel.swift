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
/// - iBook: 电子书
enum HomePage {
    case iBook
}

/// 首页ViewModel
class HomeViewModel: NSObject {
    var model : HomeModel!
    var homeUri : HomePage!
    
    
    override init() {
        
        super.init()
    }

    class func configureHomeDataSource() -> Array<HomeViewModel> {
        var modelArray = [HomeViewModel]()
        let titleArray = ["电子书"]
        let pageArray = [HomePage.iBook]
        
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
