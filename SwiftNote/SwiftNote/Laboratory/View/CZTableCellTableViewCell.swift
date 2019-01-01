//
//  CZTableCellTableViewCell.swift
//  SwiftNote
//
//  Created by huang qing on 2018/12/31.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class CZTableCellTableViewCell: UITableViewCell, CZChildScrollViewDelegate {
    
    var childScroll : CZChildScrollView!
    var czDelegate : CZChildScrollViewDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        childScroll = CZChildScrollView(frame: self.bounds)
        childScroll.backgroundColor = UIColor.randomColor
        childScroll.czDelegate = self
        self.contentView.addSubview(childScroll)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustComponents() {
        childScroll.frame = CGRect(x: 0, y: 0, width: self.qnBoundsWidth, height: self.qnBoundsHeight)
        childScroll.contentSize = CGSize(width: childScroll.qnBoundsWidth, height: qnBoundsHeight * 2)
    }
    
    func czChildScrollDidScrollToTop() {
        if czDelegate != nil {
            return czDelegate!.czChildScrollDidScrollToTop()
        }
    }
    
    func czscrollCanScrolled() -> Bool {
        if czDelegate != nil {
            return czDelegate!.czscrollCanScrolled()
        }
        
        return false
    }
}
