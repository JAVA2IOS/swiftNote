//
//  HomeViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/17.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import UIKit

class HomeViewController: SNBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    /// 子控件
    func addSubviews() -> Void {
        let cardView = UIView(frame: CGRect(x: offset15, y: Int(navHeight), width: Int(screenWidth - Float(offset15 * 2)), height: size50))
        self.view.addSubview(cardView)
        cardView.backgroundColor = UIColor.red
    }
}
