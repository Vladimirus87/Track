//
//  SettingsActivityViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsActivityViewController: MTViewController, MTSearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelTitle: MTLabel!
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var constraintTableViewData: NSLayoutConstraint!
    @IBOutlet weak var searchBar: MTSearchBar!
    @IBOutlet weak var viewTopbar: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    var dataArray : NSMutableArray!
    var dataFullList : NSArray!
    
    let cellIdentifier = "SettingsActivityTableViewCell"

    var selectedCategory : MTCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = NSMutableArray.init()
        dataFullList = NSArray.init(array: selectedCategory!.activities)
    
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        searchBarText(nil)
        searchTxtField.placeholder = LS("search")
    }
    
    
    // MARK: - MTSearchBarDelegate
    
    func searchBarText(_ search: String?) {
        
        self.upateDataArray(search)
        self.tableViewData.reloadData()
        
    }
    
    func upateDataArray(_ search: String?) {
        
        self.dataArray.removeAllObjects()
        
        guard let text = search else {
            self.dataArray.addObjects(from: dataFullList as! [Any])
            return
        }
        
        if (text.count > 0) {
            for item in dataFullList {
                let name = (item as! MTSearchObject).searchValue()
                if (name.lowercased().range(of: text.lowercased()) != nil) {
                    dataArray.add(item)
                }
            }
        } else {
            self.dataArray.addObjects(from: dataFullList as! [Any])
        }
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsActivityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        let activity = (dataArray[indexPath.row] as! MTActivity)
        
        cell.updateWithActivity(activity: activity, isSelected:DataManager.shared.activityInQuickAccessList(activity.activityId))
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewData.deselectRow(at: indexPath, animated: true)
        
        let activity = (dataArray[indexPath.row] as! MTActivity)
        if DataManager.shared.activityInQuickAccessList(activity.activityId) {
            DataManager.shared.removeActivity(activity.activityId)
        } else {
            DataManager.shared.addActivity(activity, category: selectedCategory!)
        }
        tableView.reloadData()
        
    }
        
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = self.selectedCategory?.name;
        
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
