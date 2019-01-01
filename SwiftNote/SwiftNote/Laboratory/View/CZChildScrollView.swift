//
//  CZChildScrollView.swift
//  SwiftNote
//
//  Created by huang qing on 2018/12/31.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//


protocol CZChildScrollViewDelegate {
    func czscrollCanScrolled() -> Bool
    
    func czChildScrollDidScrollToTop()
}

import UIKit

class CZChildScrollView: UIScrollView, UIScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var czDelegate : CZChildScrollViewDelegate?
    
    var canScroll = true
    var currentPoint = CGPoint.zero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        
        let childView = UIView(frame: CGRect(x: 0, y: 200, width: screenWidth, height: 100))
        childView.backgroundColor = .white
        self.addSubview(childView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let current = scrollView.contentOffset
        
        if current.y < 0 {
            scrollView.contentOffset = CGPoint.zero
//            print("内部：滑倒顶部")
            if czDelegate != nil {
                czDelegate!.czChildScrollDidScrollToTop()
            }
            return
        }
        
        
        var scrolled = false
        
        if czDelegate != nil {
            scrolled = czDelegate!.czscrollCanScrolled()
        }
        
        if !scrolled {
            self.contentOffset = currentPoint
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        currentPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        czDelegate?.czChildScrollDidScrollToTop()
    }
}
