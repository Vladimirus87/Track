//
//  AchievementsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class AchievementsViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var viewProgressValue: UIView!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let headerIdentifier = "AchievementsHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewData.register(UINib.init(nibName: headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
    }

    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AchievementTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        return cell
        
    }

    
    // MARK: - Notifications
    
    override func updateColorScheme() {
     
        self.viewProgress.backgroundColor = Config.shared.baseColor(0.2)
        self.viewProgressValue.backgroundColor = Config.shared.baseColor()
        
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
