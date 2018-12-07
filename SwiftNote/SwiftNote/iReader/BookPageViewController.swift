//
//  BookPageViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookPageViewController: UIViewController {
    var attributesDic : Dictionary<String, Any>!
    
    var contentModel : BookContentModel!
    private var contentView : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        configureContentView()
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.firstLineHeadIndent = 40 // 首行缩进
        
        if (contentModel == nil) {
            return
        }
        let attributedString = NSMutableAttributedString(string: contentModel.content!)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.string.count))

        contentView.attributedText = attributedString
    }
    
    func configureContentView() {
        contentView = UILabel.init(frame: CGRect(x: 10, y: 10, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height - 20))
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.textColor = .red
        contentView.textAlignment = .justified
        contentView.lineBreakMode = .byWordWrapping
        contentView.numberOfLines = 0
        
        self.view.addSubview(contentView)
    }
}
