//
//  SNBaseController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/17.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import UIKit

class SNBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.navigationBar.barTintColor = UIColor.NavigationBackgroundColor()
    }
    

}
