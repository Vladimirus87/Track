//
//  PageViewController.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 15.05.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit


protocol PageControllerDelegate {
    
    func pageWasScrollToIndex(_ index: Int)
}

class PageViewController: UIPageViewController {
    
    var dataArray : NSArray!
    var pageDelegate: PageControllerDelegate?
    var orderedViewControllers = [MTViewController]()
    var indexx = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "MainDashboard", ofType: "plist")
        if let dataArray = NSArray(contentsOfFile: path!){
            for index in 0..<dataArray.count {
                let tabInfo = dataArray[index] as! NSDictionary
                
                let storyboardName = tabInfo.object(forKey: "storyboard") as! String
                let controllerName = tabInfo.object(forKey: "controller") as! String
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: controllerName) as! MTViewController
                orderedViewControllers.append(controller)
            }
        }
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }
    
    
//    func goToPage(index: Int) {
//        if index < viewControllers.count {
//            pageVC!.setViewControllers([viewControllers[index]], direction: .Forward, animated: true, completion: nil)
//        }
//    }
    
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController as! MTViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
//            scrollToViewController(nextViewController, direction: direction)
            self.setViewControllers([nextViewController], direction: direction, animated: true, completion: nil)
        }
    }
    
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
    
//    func scrollToViewController(index newIndex: Int) {
//        if let firstViewController = viewControllers?.first,
//            let currentIndex = orderedViewControllers.index(of: firstViewController as! MTViewController) {
//            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
//            let nextViewController = orderedViewControllers[newIndex]
//            scrollToViewController(nextViewController, direction: direction)
//        }
//    }
    
    
//    private func scrollToViewController(viewController: UIViewController,
//                                        direction: UIPageViewControllerNavigationDirection = .forward) {
//        setViewControllers([viewController], direction: direction,
//                           animated: true,
//                           completion: { (finished) -> Void in
//                            // Setting the view controller programmatically does not fire
//                            // any delegate methods, so we have to manually notify the
//                            // 'tutorialDelegate' of the new index.
//                            self.notifyTutorialDelegateOfNewIndex()
//        })
//    }
    
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
//    private func notifyTutorialDelegateOfNewIndex() {
//        if let firstViewController = viewControllers?.first,
//            let index = orderedViewControllers.index(of: firstViewController as! MTViewController) {
//            tutorialDelegate?.tutorialPageViewController(self,
//                                                         didUpdatePageIndex: index)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! MTViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController as! MTViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

    
}

extension PageViewController: UIPageViewControllerDelegate {


    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: pendingViewControllers.first as! MTViewController) else {
            return
        }
        indexx = viewControllerIndex
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        

        if completed {
            pageDelegate?.pageWasScrollToIndex(self.indexx)
        }
    }
}









