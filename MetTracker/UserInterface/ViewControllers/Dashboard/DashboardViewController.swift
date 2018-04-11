//
//  DashboardViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gaugeProgress: MTGauge!
    @IBOutlet weak var labelWeek: MTLabel!
    @IBOutlet weak var labelWeekday: MTLabel!
    
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var buttonPlus: UIButton!

    var themes = ["DashboardQuoteTableViewCell", "DashboardPictureTableViewCell", "DashboardCrabsTableViewCell"]
    let dashboardHint = "DashboardHintTableViewCell"
    
    var showingThem: String {
        return themes[UserDefaults.standard.integer(forKey: "designTheme")]
    }
    
//

    
    var cellIdentifiers = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cellIdentifiers = [showingThem, "DashboardInfoTableViewCell"]
        
        if UserDefaults.standard.bool(forKey: "addHint") {
            cellIdentifiers.insert(dashboardHint, at: 0)
        }
        
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        updateUI()
    }





    override func resizeSubviews() {
        super.resizeSubviews()
        
        
    }
    
    
     // MARK: - UI
    
    func updateUI() {
        
        gaugeProgress.updateWithProgress(12.0 / 18.0, width: 8.0, color: Config.shared.baseColor())
        tableViewData.reloadData()
        
    }
    
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = cellIdentifiers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        
        switch cell {
        case is DashboardHintTableViewCell :
            (cell as! DashboardHintTableViewCell).delegate = self
        case is DashboardInfoTableViewCell :
            (cell as! DashboardInfoTableViewCell).delegate = self
            
        default:
            break
        }
        
        return cell
        
    }

    
    
    // MARK: - Actions
    

    @IBAction func buttonPlusPressed(_ sender: UIButton) {
            
        performSegue(withIdentifier: "toTrackingVC", sender: self)
    }
    

    // Mark: - Notifications
    
    override func updateColorScheme() {
        updateUI()
        
        buttonPlus.backgroundColor = Config.shared.baseColor()
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





extension DashboardViewController: DashboardHintTableViewCellDelegate {
    
    
    
    func closeBtnPressed() {
        
        UserDefaults.standard.set(false, forKey: "addHint")
        cellIdentifiers.remove(at: 0)
        tableViewData.reloadData()
    }
    
    func showSettingsBtnPressed() {
        
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsDashboardDesignViewController") as! SettingsDashboardDesignViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

}




extension DashboardViewController: DashboardInfoTableViewCellDelegate {
    func infoBtnPressed() {
        
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsTutorialViewController") as! SettingsTutorialViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}



