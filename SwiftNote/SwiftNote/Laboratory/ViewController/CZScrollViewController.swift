//
//  CZScrollViewController.swift
//  SwiftNote
//
//  Created by huang qing on 2018/12/31.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class CZScrollViewController: SNBaseController {
    
    var mainTable : CZTable!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainScroll = UIScrollView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: screenHeight - navHeight - 44))
        mainScroll.contentSize = CGSize(width: screenWidth * 2, height: mainScroll.qnBoundsHeight)
        mainScroll.backgroundColor = .yellow
        mainScroll.isPagingEnabled = true
        self.view.addSubview(mainScroll)
        
        mainTable = CZTable(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: mainScroll.qnBoundsHeight), style: .plain)
        mainScroll.addSubview(mainTable)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
