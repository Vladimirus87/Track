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

    let themes = ["DashboardQuoteTableViewCell", "DashboardPictureTableViewCell", "DashboardCrabsTableViewCell"]
    
    var showingThem: String {
        return themes[UserDefaults.standard.integer(forKey: "designTheme")]
    }
    
    var cellIdentifiers = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cellIdentifiers = ["DashboardHintTableViewCell", showingThem, "DashboardInfoTableViewCell"]
        
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
