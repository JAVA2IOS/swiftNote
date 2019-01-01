//
//  HomeViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/9/17.
//  Copyright © 2018年 CodeZ Huang. All rights reserved.
//

import UIKit

class HomeViewController: SNBaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    let defaultReuseIdentifier = "cz_defaultReuseIdentifier"
    var homeModels = [HomeViewModel]()
    
    
    var itemsCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeModels = HomeViewModel.configureHomeDataSource()
        
        addSubviews()
    }
    
    /// 子控件
    func addSubviews() -> Void {
        configureContainer()
    }
    
    func configureContainer() -> Void {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets(top: CGFloat(offset15), left: CGFloat(offset15), bottom: CGFloat(offset15), right: CGFloat(offset15))
        flowLayout.minimumLineSpacing = CGFloat(offset15)
        flowLayout.minimumInteritemSpacing = CGFloat(offset15)
        flowLayout.itemSize = CGSize(width: (screenWidth - CGFloat(offset15) * 3) / 2, height: 100)
        
        itemsCollectionView = UICollectionView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: screenHeight - navHeight - 44), collectionViewLayout: flowLayout)
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: defaultReuseIdentifier)
        itemsCollectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(itemsCollectionView)
    }
    
    
    // MARK: - 协议实现
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultReuseIdentifier, for: indexPath)
        collectionViewCell.backgroundColor = UIColor.white
        collectionViewCell.qn_addRoundCorner(corner: .allCorners, radius: 10)
        let homeCell = collectionViewCell as! HomeCollectionViewCell
        homeCell.homeModel = homeModels[indexPath.row]
        
        return homeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeCell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        
        let homeModel = homeCell.homeModel
        
        print("\(String(homeModel!.model.homeTitle!))")
        
        switch homeModel!.homeUri as HomePage {
        case .none:
            break
        case .iBook:
            self.pushChildController(controllerName: NSStringFromClass(BookReaderViewController.self))
            break
        case .news:
            self.pushChildController(controllerName: NSStringFromClass(OverLayViewController.self))
            break
        case .demo:
            self.pushChildController(controllerName: NSStringFromClass(CZScrollViewController.self))
            break
        }
        
    }
    
}
