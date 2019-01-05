//
//  CZTable.swift
//  SwiftNote
//
//  Created by huang qing on 2018/12/31.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class CZTable: UITableView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CZChildScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var canScroll = true
    
    var currentPoint : CGPoint!
    
    var distance : CGFloat = 0
    
    

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor.white
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
//            return screenHeight - navHeight - 44
            return 200
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            var multiCell = tableView.dequeueReusableCell(withIdentifier: "specialCellIdentifier") as? CZTableCellTableViewCell
            if multiCell == nil {
                multiCell = CZTableCellTableViewCell(style: .default, reuseIdentifier: "specialCellIdentifier")
            }
            
            multiCell!.czDelegate = self
            
            return multiCell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "normalCellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "normalCellIdentifier")
        }
        cell?.backgroundColor = UIColor.white
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let specialCell = cell as! CZTableCellTableViewCell
            let currentRect = tableView.rectForRow(at: indexPath)
            let rectAtTable = tableView.convert(currentRect, to: tableView)
            distance = min(rectAtTable.origin.y + rectAtTable.size.height - tableView.qnBoundsHeight, 0)
            print("当前的坐标值：\(distance)")
            specialCell.adjustComponents()
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let otherClass = otherGestureRecognizer.view!
        
        if otherClass is CZChildScrollView {
            return true
        }
        
        return false
    }
    
    func czscrollCanScrolled() -> Bool {
        if self.contentOffset.y >= distance {
            canScroll = false
            print("内部可以滚动")
            return true
        }
        print("内部不能滚动")
        return false
    }
    
    func czChildScrollDidScrollToTop() {
        print("内部滚动到顶部了")
        canScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !canScroll {
            print("外部：不能滑\(scrollView.contentOffset.y)")
            scrollView.contentOffset = currentPoint
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }else {
            print("外部：可以滑动")
            currentPoint = scrollView.contentOffset
        }
    }
}
