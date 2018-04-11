//
//  SettingsTextSizeViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 18.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTextSizeViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelTitle: MTLabel!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "SettingsTextSizeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Settings.shared.textSizes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTextSizeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        
        let data = Settings.shared.textSizes[indexPath.row] as! [String : Any]
        
        cell.updateWithData(data : data)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        UserDefaults.standard.set(indexPath.row, forKey: "SettingsTextSize")
        
        Config.shared.textSize = indexPath.row
        tableView.reloadData()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSubtitle"), object: nil)
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("text_size")
        
    }
    
    // MARK: - Notifications
    
    override func updateTextSize() {
        
        self.labelTitle.updateTextSize()
        self.tableViewData.reloadData()
        
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
