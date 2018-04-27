//
//  TrackingSuccessViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class TrackingSuccessViewController: MTViewController, UITableViewDelegate, UITableViewDataSource, TrackingSuccessImageTableViewCellDelegate {
    
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var buttonOk: MTButton!
    
    var cellIdentifier : String!
    let cellIdentifierText = "TrackingSuccessTextTableViewCell"
    
    var newTrackMets: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData.delegate = self
        tableViewData.dataSource = self
        
        cellIdentifier = "TrackingSuccessImageTableViewCell"
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableViewData.register(UINib.init(nibName: cellIdentifierText, bundle: nil), forCellReuseIdentifier: cellIdentifierText)
        
    }

    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackingSuccessImageTableViewCell
            cell.delegate = self
            
            let metsCount = UserDefaults.standard.object(forKey: "countOfMets") as? Float ?? 0
            
            cell.startAnimationWith(lastUserMetsCount: metsCount, newUserMetsCount: newTrackMets + metsCount)
//            cell.startAnimationWith(lastUserMetsCount: 1, newUserMetsCount: 9)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierText, for: indexPath) as? TrackingSuccessTextTableViewCell  else {
                fatalError("The dequeued cell is not an instance of \(cellIdentifierText).")
            }
            
            return cell
            
        }
        
    }
    
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        self.buttonOk.backgroundColor = Config.shared.darkColor()
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("success")
    }
    
    
    // MARK: - Actions

    @IBAction func buttonOkPressed(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init("reloadDashboard"), object: nil)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TrackingSuccessImageTableViewCellDelegate
    func endAnimation() {
        
        let alert = UIAlertController(title: "Great!", message: LS("weekly_goal_achived"), preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
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
