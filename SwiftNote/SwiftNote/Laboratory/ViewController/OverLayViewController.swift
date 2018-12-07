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
    var collectionView : UICollectionView! = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
    }
    

    func addSubViews() {
        let collectionLayout = OverLayFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
//        collectionLayout.itemSize = CGSize(width: 200, height: 150)
        collectionLayout.sectionInset = UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: 200), collectionViewLayout: collectionLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultReuseIdentifier)
        
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
}
