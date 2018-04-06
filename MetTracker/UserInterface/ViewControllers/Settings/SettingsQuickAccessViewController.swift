//
//  SettingsQuickAccessViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsQuickAccessViewController: MTViewController, MTSearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SettingsQuickAccessTableViewCellDelegate {

    @IBOutlet weak var labelTitle: MTLabel!
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var constraintTableViewData: NSLayoutConstraint!
    @IBOutlet weak var searchBar: MTSearchBar!
    @IBOutlet weak var viewTopbar: UIView!
    
    var dataArray : NSMutableArray!
    
    let cellIdentifier = "SettingsQuickAccessTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = NSMutableArray.init()
        
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableViewData.setEditing(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBarText(self.searchBar.textFieldSearch.text)
    }

    // MARK: - MTSearchBarDelegate
    
    func searchBarText(_ search: String?) {
        
        self.upateDataArray(search)
        self.tableViewData.reloadData()
        
    }
    
    func upateDataArray(_ search: String?) {
        
        self.dataArray.removeAllObjects()
        
        let dataFullList = DataManager.shared.quickAccessArray
        
        guard let text = search else {
            
            self.dataArray.addObjects(from: dataFullList)
            return
            
        }
        
        if (text.count > 0) {
            
            for item in dataFullList {
                if let name = item.name {
                    if (name.lowercased().range(of: text.lowercased()) != nil) {
                        dataArray.add(item)
                    }
                }
            }
            
        } else {
            
            self.dataArray.addObjects(from: dataFullList)
            
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsQuickAccessTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.delegate = self
        cell.updateWithActivity(activity: dataArray[indexPath.row] as! Activity)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true;
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if sourceIndexPath.row != destinationIndexPath.row {
            let itemSource = dataArray[sourceIndexPath.row] as! Activity;
            let itemDestination = dataArray[destinationIndexPath.row] as! Activity;
            DataManager.shared.replaceQuickAccessItem(Int(itemSource.id), withItem: Int(itemDestination.id))
            dataArray.removeObject(at: sourceIndexPath.row)
            dataArray.insert(itemSource, at: destinationIndexPath.row)
        }
    }
    
    // MARK: - SettingsQuickAccessTableViewCellDelegate
    
    func quickAccessRemovePressed(_ activity: Activity) {
        
        DataManager.shared.removeActivity(Int(activity.id))
        searchBarText(self.searchBar.textFieldSearch.text)
        
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
        
        self.labelTitle.text = LS("quick_access");
        
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
