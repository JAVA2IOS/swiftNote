//
//  OverLayViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/6.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

/// 堆叠效果
class OverLayViewController: SNBaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    let defaultReuseIdentifier = "cz_defaultReuseIdentifier"
    let defaultHeaderReuseIdentifier = "cz_defaultHeaderReuseIdentifer"
    var targetY : CGFloat! = 0
    
    var collectionView : UICollectionView! = nil
    
    var collectionLayout : UICollectionViewFlowLayout!


    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
    }
    

    func addSubViews() {
//        let collectionLayout = OverLayFlowLayout.init()
        collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.minimumInteritemSpacing = 10
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.itemSize = CGSize(width: (screenWidth - 20 - 10) / 2, height: 150)
        collectionLayout.headerReferenceSize = CGSize(width: 0, height: 50)
        collectionLayout.sectionInset = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: screenHeight - navHeight), collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultReuseIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: defaultHeaderReuseIdentifier)
        
        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultReuseIdentifier, for: indexPath)
        collectionViewCell.backgroundColor = UIColor.randomColor
        
        return collectionViewCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: defaultHeaderReuseIdentifier, for: indexPath)
        view.backgroundColor = .randomColor
        if indexPath.section == 4 {
            targetY = view.qnOriginY;
        }
        
        return view
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let collectionView = scrollView as! UICollectionView
            let indexPaths = collectionView.indexPathsForVisibleItems
            
            let firstIndexPath = indexPaths.first
            
            let currentY = scrollView.contentOffset.y

            if firstIndexPath != nil {
                let targetIndexPath = IndexPath(row: 0, section: 4)
                let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: targetIndexPath)
                if headerView != nil {
                    collectionLayout.sectionHeadersPinToVisibleBounds = currentY >= targetY ? true : false
                }
            }
        }
    }

}
