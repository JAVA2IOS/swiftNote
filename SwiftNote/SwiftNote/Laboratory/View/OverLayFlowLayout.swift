//
//  OverLayFlowLayout.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/6.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class OverLayFlowLayout: UICollectionViewFlowLayout {
    
//    var attributesArray : Array<UICollectionViewLayoutAttributes>!
    
//    override func prepare() {
//        super.prepare()
//        let numbers = self.collectionView?.numberOfItems(inSection: 0)
//
//        attributesArray = Array<UICollectionViewLayoutAttributes>.init()
//        for i in 0..<numbers! {
//            let indexPath = IndexPath(row: i, section: 0)
//            let attributes = self.layoutAttributesForItem(at: indexPath)
//
//            attributesArray.append(attributes!)
//        }
//    }

    override var collectionViewContentSize: CGSize {
        let numbers = self.collectionView?.numberOfItems(inSection: 0)
        
        return CGSize(width: screenWidth * CGFloat(2), height: 200)
    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return attributesArray
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributeArray = super.layoutAttributesForElements(in: rect)
        
        for i in 0..<attributeArray!.count {
            let attributes = attributeArray![i]
            attributes.size = CGSize(width: 200, height: 150)
            
            let pointX = (self.collectionView?.bounds.size.width)! / 2
            attributes.center = CGPoint(x: pointX, y: (self.collectionView?.bounds.height)! / 2)
        }
        
        return attributeArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
