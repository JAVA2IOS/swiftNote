//
//  BookReaderViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookReaderViewController: SNBaseController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    var chapterModel : BookChapterModel!
    var currentPage = 0
    var currentOffset = 0
    var goForward = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBookDatas()
        
        configurePageViewController()
    }
    
    // MARK: - 数据
    func configureBookDatas() {
        chapterModel = BookChapterModel.init()
        var contentArray = [BookContentModel]()
        let contents = ["准备工作推荐使用 CocoaPods 安装 Ono 这个三方，这样可以省下很多配置的麻烦。", "如果手动导入的话按照以下步骤就好了下载Ono主分支文件 Ono 下载 ，将下面三个文件导入到工程中：", "公司一直在做一款有许多textFeild需要填写的项目，当填完第一页之后"]
        
        for texts in contents {
            let contentModel = BookContentModel.init()
            contentModel.content = texts
            contentArray.append(contentModel)
        }
        
        chapterModel.contentModels = contentArray
    }
    
    
    // MARK: - UI
    func configurePageViewController() {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionSpineLocationKey : UIPageViewControllerSpineLocation.min])
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.delegate = self
        pageVC.dataSource = self
        findPageViewControllerScrollView(pageVC)
        
        let currentVC = BookPageViewController.init()
        currentVC.contentModel = chapterModel.contentModels[currentPage]
        
        pageVC.setViewControllers([currentVC], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: - 逻辑
    func findPageViewControllerScrollView(_ pageViewController : UIPageViewController) {
        for subView in pageViewController.view.subviews {
            if subView.isKind(of: UIScrollView.self) {
                let scrollView = subView as! UIScrollView
                scrollView.delegate = self
            }
        }
    }
    
    
    // MARK: - 协议方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x) > currentOffset {
            goForward = true
        }else {
            goForward = false
        }
        currentOffset = Int(scrollView.contentOffset.x)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if goForward {
                currentPage += 1
            }else {
                currentPage -= 1
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let afterPage = currentPage + 1
        if afterPage >= chapterModel.contentModels.count {
            return nil
        }

        let nextVC = BookPageViewController.init()
        nextVC.contentModel = chapterModel.contentModels[afterPage]
        
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousPage = currentPage - 1
        if previousPage < 0 {
            return nil
        }

        let previousVC = BookPageViewController.init()
        previousVC.contentModel = chapterModel.contentModels[previousPage]
        
        return previousVC
    }
}
