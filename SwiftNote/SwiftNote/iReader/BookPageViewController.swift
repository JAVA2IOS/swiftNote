//
//  BookPageViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookPageViewController: UIViewController {
    var contentModel : BookContentModel!
    private var contentView : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureContentView()
    }
    
    func configureContentView() {
        contentView = UILabel.init(frame: self.view.bounds)
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.textColor = .red
        contentView.textAlignment = .justified
        if (contentModel != nil) {
            contentView.text = contentModel.content!
        }
        self.view.addSubview(contentView)
    }
}
