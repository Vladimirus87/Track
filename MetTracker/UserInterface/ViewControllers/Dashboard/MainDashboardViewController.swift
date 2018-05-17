//
//  MainDashboardViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MainDashboardViewController: MTViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PageControllerDelegate {

    @IBOutlet weak var collectionViewTabs: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    
    var currentController : UIViewController!
    var pageViewController: PageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
        }
    }
    
    var dataArray : NSArray!
    var currentTab: Int = 0  //1) подписаться на делегат PageVC 2) реализовать свой метод в didSelectitem для скрола 3) почистить ВС 4) заменить свайп на gesture
// {
//        didSet {
//            if (self.dataArray != nil) {
//                let tabInfo = dataArray[currentTab] as! NSDictionary
//
//                let storyboardName = tabInfo.object(forKey: "storyboard") as! String
//                let controllerName = tabInfo.object(forKey: "controller") as! String
//
//                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: controllerName) as! MTViewController
//
//                add(asChildViewController: controller)
//
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "MainDashboard", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)

//        self.currentTab = 0
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        viewContainer.addGestureRecognizer(swipeRight)
//        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
//        viewContainer.addGestureRecognizer(swipeLeft)
    }
    
//    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
//        if sender.direction == .left {
//            if currentTab < dataArray.count - 1 {
//                currentTab += 1
//            }
//        } else if sender.direction == .right {
//            if currentTab > 0 {
//                currentTab -= 1
//            }
//        }
//        self.collectionViewTabs.reloadData()
//    }
    
    
    func pageWasScrollToIndex(_ index: Int) {
        currentTab = index
        collectionViewTabs.reloadData()
    }
    
    
    


    override func resizeSubviews() {
        super.resizeSubviews()
        
        self.collectionViewTabs.layoutIfNeeded()
        self.collectionViewTabs.reloadData()
        
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var count = dataArray.count
        if (count < 1) {
            count = 1
        }
        
        return CGSize.init(width: (collectionView.bounds.size.width / CGFloat(count)), height: collectionView.bounds.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "MainDashboardCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MainDashboardCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of OnBoardingCollectionViewCell.")
        }
        
        let tabInfo = dataArray[indexPath.row] as? NSDictionary
        cell.updateWithTabInfo(tabInfo: tabInfo!, isSelected: (indexPath.row == self.currentTab))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (self.currentTab != indexPath.row) {
            pageViewController?.scrollToViewController(index: indexPath.row)
            self.currentTab = indexPath.row
            self.collectionViewTabs.reloadData()
            

        }
        
    }
    
    

    // MARK: - Content Container
    
    private func add(asChildViewController viewController: UIViewController) {
        
        if (self.currentController != nil) {
            self.remove(asChildViewController: self.currentController)
        }
        
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        viewContainer.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
        
        self.currentController = viewController
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        self.collectionViewTabs.reloadData()
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToDashboard(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destVC = segue.destination as? PageViewController {
            self.pageViewController = destVC
        }
    }
 

}
