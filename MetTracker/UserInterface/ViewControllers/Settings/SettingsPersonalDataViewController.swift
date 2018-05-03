//
//  SettingsPersonalDataViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsPersonalDataViewController: MTViewController, UITableViewDelegate, UITableViewDataSource, SettingsPersonalDataTableViewCellDelegate {
    
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var constraintTableViewData: NSLayoutConstraint!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonDeleteAllData: UIButton!
    
    let cellIdentifier = "SettingsPersonalDataTableViewCell"
    
    var profile : MTProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profile = Config.shared.profile.copy() as! MTProfile

        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.settingsPersonalDataIsUpdated()
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Settings.shared.personalData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsPersonalDataTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        let data = Settings.shared.personalData[indexPath.row] as! [String : Any]
        
        cell.updateWithData(data : data, profile: self.profile)
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.closeKeyboard()
        
        let data = Settings.shared.personalData[indexPath.row] as! [String : Any]
        
        let selectable = data["selectable"]
        if (selectable != nil) {
            //let field = data["field"] as! String
        
            if self.profile.gender == nil {
                self.profile.gender = .male
            } else {
                if self.profile.gender == .male {
                    self.profile.gender = .female
                } else {
                    self.profile.gender = .male
                }
            }
            
            settingsPersonalDataIsUpdated()
            self.tableViewData.reloadData()
            
        }
        
        
    }
    
    // MARK: - SettingsPersonalDataTableViewCellDelegate
    
    func settingsPersonalDataIsUpdated() {
        self.buttonConfirm.isUserInteractionEnabled = self.profile.isCompleted()
        self.buttonConfirm.alpha = self.buttonConfirm.isUserInteractionEnabled ? 1.0 : 0.5
    }
    
    // MARK: - Keyboard
    
    override func updateKeyboardHeight(_ height : CGFloat) {
        self.constraintTableViewData.constant = height
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @IBAction func buttonConfirmPressed(_ sender: UIButton) {
        
        Config.shared.profile = self.profile
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func buttonClearPressed(_ sender: UIButton) {
        
        self.profile.clearData()
        self.tableViewData.reloadData()
        settingsPersonalDataIsUpdated()
        
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        self.labelTitle.text = LS("personal_data")
        self.buttonDeleteAllData.setTitle(LS("delete_all_data"), for: .normal)
    }
    
    
    override func updateColorScheme() {
        buttonConfirm.backgroundColor = Config.shared.baseColor()
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
