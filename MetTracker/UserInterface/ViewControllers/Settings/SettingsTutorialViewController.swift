//
//  SettingsTutorialViewController.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 03.05.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTutorialViewController: MTViewController {
    
    @IBOutlet weak var tableViewData: UITableView!
    @IBOutlet weak var titleLbl: MTLabel!

    var dataArray: NSArray!
    let cellIdentifier = "SettingsSingleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData.dataSource = self
        tableViewData.delegate = self
        
        let path = Bundle.main.path(forResource: "SettingsTutorials", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)
        
        tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.titleLbl.text = LS("tutorial")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


extension SettingsTutorialViewController : UITableViewDelegate,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingsSingleTableViewCell
        
        let data = dataArray[indexPath.row] as! NSDictionary
        
        let cellTitle = data.object(forKey: "title") as! String
        
        if let img = UIImage(named: data.object(forKey: "image") as? String ?? "") {
            cell.imageIcon.image = img
        }
        cell.labelTitle.text = LS(cellTitle)
        cell.imageArrow.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableViewData.deselectRow(at: indexPath, animated: true)
        
        let data = dataArray[indexPath.row] as! NSDictionary
        guard let controllerIndex = data.object(forKey: "controller") as? Int else {return}
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        controller.currentPageSet = controllerIndex
        self.present(controller, animated: true)
    }
    
}
