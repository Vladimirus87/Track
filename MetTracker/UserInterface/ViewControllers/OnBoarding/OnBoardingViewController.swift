
//
//  OnBoardingViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class OnBoardingViewController: MTViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, OnBoardingCollectionViewCellDelegate {
    
    @IBOutlet weak var collectionViewPages: UICollectionView!
    
    @IBOutlet weak var buttonSkip: MTButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonNext: MTButton!
    
    let pageSets = ["OnBoarding", "Tracking"]
    var currentPageSet: Int!
    
    var dataArray : NSArray!
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewPages.register(UINib.init(nibName: "OnBoardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardingCollectionViewCell")
        self.collectionViewPages.register(UINib.init(nibName: "OnBoardingButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardingButtonCollectionViewCell")
        
    }
    
    override func resizeSubviews() {
        super.resizeSubviews()
        
        updateUIWithPageSet(currentPageSet)
        
        self.collectionViewPages.layoutIfNeeded()
        self.collectionViewPages.reloadData()
        
    }
    
    // MARK: - Initialization
    
    func updateUIWithPageSet(_ pageSet: NSInteger) {
        
        self.currentPageSet = pageSet
        let fileName = pageSets[self.currentPageSet]
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)

        self.currentPage = 0
        self.collectionViewPages.reloadData()
        self.collectionViewPages.scrollToItem(at: IndexPath.init(row: self.currentPage, section: 0), at: UICollectionViewScrollPosition.left, animated: false);
        
        updateUIWithPage(self.currentPage)
        
    }
    
    func updateUIWithPage(_ page: NSInteger) {
        
        self.currentPage = page
        self.collectionViewPages.scrollToItem(at: IndexPath.init(row: self.currentPage, section: 0), at: UICollectionViewScrollPosition.left, animated: true);
        
        self.buttonSkip.setTitle(LS("button_skip"), for: UIControlState.normal)
        self.buttonSkip.isHidden = (self.currentPage >= (dataArray.count - 1))
        
        self.pageControl.currentPage = self.currentPage
        
        if (self.currentPage < (dataArray.count - 1)) {
            self.buttonNext.setTitle(LS("button_next"), for: UIControlState.normal)
        } else {
            self.buttonNext.setTitle(LS("button_done"), for: UIControlState.normal)
        }
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func buttonSkipPressed(_ sender: UIButton) {

//        if (self.currentPageSet < (pageSets.count - 1)) {
//            updateUIWithPageSet(self.currentPageSet + 1)
//        } else {
//
        if currentPageSet == 0 {
            performSegue(withIdentifier: "unwindToStartScreen", sender: self)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
//        }
        
        
    }
    
    @IBAction func buttonNextPressed(_ sender: UIButton) {
        
        if (self.currentPage < (dataArray.count - 1)) {
            updateUIWithPage(self.currentPage + 1)
        } else {
            buttonSkipPressed(sender)
        }
        
    }
    
    // MARK: - OnBoardingCollectionViewCellDelegate
    
    func onBoardingActionPressed() {
        
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsPersonalDataViewController") as! SettingsPersonalDataViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
        
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pageInfo = dataArray[indexPath.row] as! NSDictionary
        let buttonTitle = pageInfo.object(forKey: "button") as? String
        
        let cellIdentifier = (buttonTitle == nil) ? "OnBoardingCollectionViewCell" : "OnBoardingButtonCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? OnBoardingCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of OnBoardingCollectionViewCell.")
        }
        
        cell.updateWithPageInfo(pageInfo: pageInfo)
        cell.delegate = self
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((round(scrollView.contentOffset.x).truncatingRemainder(dividingBy: round(scrollView.frame.size.width))) == 0) {
            let page = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
           
            if (page != self.currentPage) {
                updateUIWithPage(page)
            }
        }
        
    }
    

    // Mark: - Notifications
    
    override func updateColorScheme() {
        
        self.buttonSkip.tintColor = Config.shared.baseColor()
        
        self.pageControl.pageIndicatorTintColor = Config.shared.baseColor(0.2)
        self.pageControl.currentPageIndicatorTintColor = Config.shared.baseColor()
        
        self.buttonNext.tintColor = Config.shared.baseColor()
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
