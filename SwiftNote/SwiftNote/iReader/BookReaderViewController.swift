//
//  BookReaderViewController.swift
//  SwiftNote
//
//  Created by qeeniao35 on 2018/12/3.
//  Copyright © 2018 CodeZ Huang. All rights reserved.
//

import UIKit

class BookReaderViewController: SNBaseController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, PageViewDataSource {
    var chapterModel : BookChapterModel!
    var pageView : PageView!
    
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

        pageView = PageView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: self.view.frame.size.height - navHeight))
        self.view.addSubview(pageView)
        pageView.backgroundColor = .white
        
        chapterModel = BookChapterModel.init()
        var contentArray = [BookContentModel]()
        let contents = ["准备工作推荐使用 CocoaPods 安装 Ono 这个三方。如果手动导入的话按照以下步骤就好了下载Ono主分支文件 Ono 下载如果手动导入的话按照以下步骤就好了下载Ono主分支文件 Ono 下载\n这样可以省下很多配置的麻烦。", "如果手动导入的话按照以下步骤就好了下载Ono主分支文件 Ono 下载 ，将下面三个文件导入到工程中：", "公司一直在做一款有许多textFeild需要填写的项目，当填完第一页之后"]

        for texts in contents {
            let contentModel = BookContentModel.init()
            contentModel.content = texts
            contentArray.append(contentModel)
        }
        
        chapterModel.contentModels = contentArray
    }
    
    
    // MARK: - UI
    func configurePageViewController() {
        pageView.contentModel = chapterModel.contentModels[currentPage]
        pageView.configureContent()
        pageView.pageDelegate = self
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
    func pageViewDataSourceTurnNextPage() -> BookContentModel? {
        if currentPage >= (chapterModel.contentModels.count - 1) {
            return nil
        }
        currentPage += 1
        return chapterModel.contentModels[currentPage]
    }
    
    func pageViewDataSourceTurnPreviousPage() -> BookContentModel? {
        if currentPage <= 0 {
            return nil
        }
        currentPage -= 1
        return chapterModel.contentModels[currentPage]
    }
    
    
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [String: Any]?) -> [UIPageViewController.OptionsKey: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIPageViewController.OptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIPageViewControllerOptionsKey(_ input: UIPageViewController.OptionsKey) -> String {
	return input.rawValue
}
