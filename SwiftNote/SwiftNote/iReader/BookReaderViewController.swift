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
        chapterModel = BookChapterModel.init()
        var contentArray = [BookContentModel]()
        let contents = ["这是第一页。\n 想必以前QQ空间的点赞效果大家都知道吧，点赞之后按钮周围会有一圈爆裂的小圆点；还有微信的红包雨表情动画等，以及烟花，火焰效果。这些看似很炫酷的动画可能让我们敬而远之，但是其实iOS封装的很好，利用简单的几行代码就能完成很炫酷的动画效果。由于目前正在玩儿iOS动画的内容，利用iOS的CAEmitterLayer结合CAEmitterCell能够达这些效果。不BB了，先上几个效果图。代码已传githubEmitterAnimation。", "这是第二页\n马丹 有没有办法一次性放很多个gif呀。。。。。。。\nCAEmitterLayer与CAEmitterCell\nCAEmitterLayer是CALayer的一个常用子类,CALayer的子类有很多，如果能很好的使用它们会得到一些意想不到的效果。CAEmitterLayer就是其中之一，CAEmitterLayer是用于实现基于Core Animation的粒子发生器系统。", "这是第三页\n周末闲着无聊，想起最近遇到一个关于文字显示设置的小问题，想着以后可能还会经常用到，所以趁这个时候一起整理一下，方便以后备用"]

        for i in 0 ..< contents.count {
            let contentModel = BookContentModel.init()
            contentModel.content = contents[i]
            contentModel.characterSort = i
            contentModel.location = 10 * i
            contentArray.append(contentModel)
        }
        
        chapterModel.contentModels = contentArray
    }
    
    
    // MARK: - UI
    func configurePageViewController() {
        pageView = PageView(frame: CGRect(x: 0, y: navHeight, width: screenWidth, height: self.view.frame.size.height - navHeight))
        self.view.addSubview(pageView)
        pageView.backgroundColor = .white
        pageView.currentContentModel = chapterModel.contentModels![currentPage]
        pageView.pageDelegate = self
        pageView.registContainerClass(PageContainer.self)
        pageView.animated = false
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
    func pageViewDataSourceTurnNextPage(_ currentModel: BookContentModel?) -> BookContentModel? {
        if currentModel == nil {
            return nil
        }
        
        let sortNumber = (currentModel?.characterSort)! + 1
        
        let dataArray : Array = chapterModel.contentModels!
        
        let filterDatas = dataArray.filter { (currentModel) -> Bool in
            if currentModel.characterSort == sortNumber {
                return true
            }
            
            return false
        }
        
        return filterDatas.first
    }
    
    func pageViewDataSourceTurnPreviousPage(_ currentModel: BookContentModel?) -> BookContentModel? {
        if currentModel == nil {
            return nil
        }
        
        let sortNumber = (currentModel?.characterSort)! - 1
        
        let dataArray : Array = chapterModel.contentModels!
        
        let filterDatas = dataArray.filter { (currentModel) -> Bool in
            if currentModel.characterSort == sortNumber {
                return true
            }
            
            return false
        }
        
        return filterDatas.first
    }
    
    func pageViewDataSourceConfigureData(_ currentPageView: UIView, dataModel: BookContentModel?) {
        if currentPageView is PageContainer {
            let pageView = currentPageView as! PageContainer
            pageView.currentPageModel = dataModel
            pageView.backgroundColor = UIColor.CodeColor("FFDEAD")
        }
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
        if afterPage >= chapterModel.contentModels!.count {
            return nil
        }

        let nextVC = BookPageViewController.init()
        nextVC.contentModel = chapterModel.contentModels![afterPage]
        
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousPage = currentPage - 1
        if previousPage < 0 {
            return nil
        }

        let previousVC = BookPageViewController.init()
        previousVC.contentModel = chapterModel.contentModels![previousPage]
        
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
