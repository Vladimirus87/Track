//
//  TrackingActivityViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class TrackingActivityViewController: MTViewController, UITableViewDelegate, UITableViewDataSource, MTSearchBarDelegate {

    var selectedCategory : MTCategory?
    var selectedCategoryId : Int?
    var selectedActivityId : Int?

    var dataFullList : NSArray!
    var dataArray : NSMutableArray!
    var dataQuickAccessArray : NSMutableArray!
    
    var cellIdentifier = "TrackingActivityTableViewCell"
    
    @IBOutlet weak var tableViewData: UITableView!
    
    @IBOutlet weak var viewTopbar: UIView!
    
    @IBOutlet weak var buttonTitle: MTButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var searchBar: MTSearchBar!
    
    let headerIdentifier = "TrackingActivityHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonConfirm.isEnabled = false;
        
        dataArray = NSMutableArray.init()
        dataQuickAccessArray = NSMutableArray.init()
        
        if (selectedCategory == nil) {
            self.dataFullList = NSArray.init(array: DataManager.shared.categoryArray)
            //self.tableViewData.rowHeight = 112.0
            
            self.buttonTitle.setImage(nil, for: UIControlState.normal)
            self.buttonTitle.isUserInteractionEnabled = false;
            
            self.tableViewData.register(UINib.init(nibName: "TrackingCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackingCategoryTableViewCell")
            
        } else {
            self.dataFullList = NSArray.init(array: selectedCategory!.activities)
        }
        
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.tableViewData.register(UINib.init(nibName: headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
        searchBarText(nil)
        
    }

    // MARK: - MTSearchBarDelegate
    
    func searchBarText(_ search: String?) {
        
        self.upateDataArray(search)
        self.tableViewData.reloadData()
        
    }
    
    func upateDataArray(_ search: String?) {
        
        self.dataArray.removeAllObjects()
        self.dataQuickAccessArray.removeAllObjects()
        
        guard let text = search else {
            
            self.dataArray.addObjects(from: dataFullList as! [Any])
            self.dataQuickAccessArray.addObjects(from: DataManager.shared.quickAccessArray)
            return
            
        }
        
        if (text.count > 0) {
            
            for item in dataFullList {
                let name = (item as! MTSearchObject).searchValue()
                if (name.lowercased().range(of: text.lowercased()) != nil) {
                    dataArray.add(item)
                }
            }
            
            for item in DataManager.shared.quickAccessArray {
                if let name = item.name {
                    if (name.lowercased().range(of: text.lowercased()) != nil) {
                        dataQuickAccessArray.add(item)
                    }
                }
            }
            
        } else {
            
            self.dataArray.addObjects(from: dataFullList as! [Any])
            self.dataQuickAccessArray.addObjects(from: DataManager.shared.quickAccessArray)
            
        }
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (selectedCategory == nil) {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (selectedCategory == nil) {
            if (section == 0) && (dataQuickAccessArray.count == 0) {
                return 0.0
            }
            return 32.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (selectedCategory == nil) {
            if (section == 0) && (dataQuickAccessArray.count == 0) {
                return nil
            }
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? TrackingActivityHeaderView {
                
                headerView.viewBg.backgroundColor = Config.shared.darkColor()
                
                if (section == 0) && (dataQuickAccessArray.count > 0)  {
                    headerView.labelTitle.text = LS("quick_access").uppercased()
                } else {
                    headerView.labelTitle.text = LS("categories").uppercased()
                }
                
                return headerView
            }
            
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedCategory == nil) && (section == 0) {
            return dataQuickAccessArray.count
        } else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (selectedCategory == nil) && (indexPath.section == 1) {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingCategoryTableViewCell", for: indexPath) as? TrackingCategoryTableViewCell  else {
                fatalError("The dequeued cell is not an instance of TrackingCategoryTableViewCell.")
            }
            
            cell.updateWithCategory(category: dataArray[indexPath.row] as! MTCategory)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrackingActivityTableViewCell  else {
                fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
            }
            
            if (selectedCategory == nil) {
                let activity = dataQuickAccessArray[indexPath.row] as! Activity
                cell.updateWithQuickAccessActivity(activity: activity, isSelected:(self.selectedActivityId != nil && self.selectedActivityId! == Int(activity.id)))
                
            } else {
                let activity = (dataArray[indexPath.row] as! MTActivity)
                cell.updateWithActivity(activity: activity, isSelected:(self.selectedActivityId != nil && self.selectedActivityId == activity.activityId))
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedCategory == nil) && (indexPath.section == 1) {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TrackingActivityViewController") as! TrackingActivityViewController
            controller.selectedCategory = (dataArray[indexPath.row] as! MTCategory)
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else {
            
            if (selectedCategory == nil) {
                let activity = dataQuickAccessArray[indexPath.row] as! Activity
                if ((self.selectedActivityId != nil) && (self.selectedActivityId! == activity.id)) {
                    selectedActivityId = nil
                    selectedCategoryId = nil
                } else {
                    selectedActivityId = Int(activity.id)
                    selectedCategoryId = Int(activity.categoryId)
                }
            } else {
                let activity = (dataArray[indexPath.row] as! MTActivity)
                if ((self.selectedActivityId != nil) && (self.selectedActivityId! == activity.activityId)) {
                    selectedActivityId = nil
                    selectedCategoryId = nil
                } else {
                    selectedActivityId = activity.activityId
                    selectedCategoryId = self.selectedCategory?.categoryId
                }
            }
            
            self.buttonConfirm.isEnabled = (selectedActivityId != nil);
            tableView.reloadData()
            
        }
        
        
    }

    // MARK: - Actions
    
    @IBAction func buttonTitlePressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToTrackingScreen", sender: self)
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonConfirmPressed(_ sender: UIButton) {
        
        guard let config = TrackingManager.shared.config else {
            return
        }
        
        if (self.selectedActivityId != nil) {
            config.activityId = self.selectedActivityId!
            config.categoryId = self.selectedCategoryId!
            
            TrackingManager.shared.saveTracking(tracking: config)
        }
        
    }
    
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        self.viewTopbar.backgroundColor = Config.shared.baseColor()
        self.searchBar.backgroundColor = Config.shared.darkColor()
        self.tableViewData.backgroundColor = Config.shared.darkColor()
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.buttonTitle.setTitle(LS("choose_activity"), for: UIControlState.normal)
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSuccessVC", let destVC = segue.destination as? TrackingSuccessViewController {
            
            let track = TrackingManager.shared.savedTrack
            destVC.newTrackMets = track?.mets ?? 0
        }
    }
 

}
