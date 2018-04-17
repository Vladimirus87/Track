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
    
    var cellIdentifiers = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPictureCell), name: NSNotification.Name.init("reloadDATA"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    
    func registerCells() {
        cellIdentifiers = [showingThem, "DashboardInfoTableViewCell"]
        
        if UserDefaults.standard.bool(forKey: "addHint") {
            cellIdentifiers.insert(dashboardHint, at: 0)
        }
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }



    override func resizeSubviews() {
        super.resizeSubviews()

    }
    
    
     // MARK: - UI
    
    func updateUI() {
        
        gaugeProgress.updateWithProgress(12.0 / 18.0, width: 8.0, color: Config.shared.baseColor())
        tableViewData.reloadData()
    }
    
    
    @objc func reloadPictureCell() {
        DispatchQueue.main.async {
            self.registerCells()
            let rowIP = IndexPath(row: 1, section: 0)
            self.tableViewData.reloadRows(at: [rowIP], with: .automatic)
        }
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
            
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 248
        }
        return UITableViewAutomaticDimension
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



