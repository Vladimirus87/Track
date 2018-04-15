//
//  SettingsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray : NSArray!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "Settings", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)

        let types = ["Single", "Subtitle"]
        for type in types {
            let cellIdentifier = "Settings\(type)TableViewCell"
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reloadDATA"), object: nil)
    }
    
    
    
    
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section < dataArray.count - 1) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        footer.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        return footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array = dataArray[section] as! NSArray
        return array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array = dataArray[indexPath.section] as! NSArray
        let data = array[indexPath.row] as! NSDictionary
        
        let type = data.object(forKey: "type") as! String
        let cellIdentifier = "Settings\(type)TableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.updateWithData(data: data)
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        let array = dataArray[indexPath.section] as! NSArray
        let data = array[indexPath.row] as! NSDictionary
        
        guard let controllerName = data.object(forKey: "controller") as? String else {
            return
        }
                
        let storyboard = UIStoryboard.init(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: controllerName) as! MTViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    // MARK: - Notifications
    
    override func updateTextSize() {

        reload()
    }
    
    
    @objc func reload() {
        self.tableViewData.reloadData()
    }
    
    
}
