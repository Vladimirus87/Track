//
//  SettingsMiscActivitiesViewController.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 11.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import MessageUI

class SettingsMiscActivitiesViewController: MTViewController {
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "SettingsMiscActivitiesCell"
    var data = [Tracking]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataFullList : [MTCategory]!
    var activities = [MTActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataFullList = DataManager.shared.categoryArray
        
        tableViewData.delegate = self
        tableViewData.dataSource = self
        getData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getData() {
        do {
            data = try contex.fetch(Tracking.fetchRequest())
            
            for i in data {
                if let activity = getDataOfActivity(ctId: Int(i.categoryId), actId: Int(i.activityId)) {
                    activities.append(activity)
                }
            }
            
        } catch {
            print("Fetching Failed")
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exportPressed(_ sender: UIButton) {
        exportDatabase()
    }
    

    func getDataOfActivity(ctId: Int, actId: Int) -> MTActivity? {
        
        let actArr = dataFullList[ctId - 1].activities
        for activity in actArr {
            if activity.activityId == actId {
                return activity
            }
        }
        return nil
    }
    
    
    
    
    
    func exportDatabase() {
        let exportString = createExportString()
        sendEmail(exportString: exportString)
    }

    
    func createExportString() -> String {
        var dateItem: String
        var nameItem: String
        var metsItem: Float
        var timeItem: Float
        var heartItem: Int
        
        var export: String = ""
        for (index, itemList) in data.enumerated() {
            if index <= data.count - 1 {
                let date = itemList.value(forKey: "date") as! Date?
                let name = getDataOfActivity(ctId: Int(itemList.categoryId), actId: Int(itemList.activityId))
                let mets = itemList.value(forKey: "mets") as! Float?
                let time = itemList.value(forKey: "time") as! Float?
                let heart = itemList.value(forKey: "heartrate") as! Int?
                
                dateItem = date?.string(with: "MMM dd, yyyy") ?? "--"
                nameItem = name?.name ?? "--"
                metsItem = mets ?? 0.0
                timeItem = time ?? 0.0
                heartItem = heart ?? 0
                
                export += "Date: \(String(describing: dateItem)) \n Activity: \(String(describing: nameItem)) \n Mets: \(String(describing: metsItem)) \n Time: \(String(describing: timeItem)) \n Heart: \(String(describing: heartItem)) \n \n \n "
            }
        }
        print("This is what the app will export: \(export)")
        return export
    }
}






extension SettingsMiscActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewData.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.detailTextLabel?.text = activities[indexPath.row].name
        
        let date = data[indexPath.row].date as Date?
        cell.textLabel?.text = date?.string(with: "dd-MM-yyyy")
        return cell
    }
}



extension SettingsMiscActivitiesViewController: MFMailComposeViewControllerDelegate {
    
    
    func sendEmail(exportString: String) {
        
        let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setMessageBody("<p>MET Trecker</p>", isHTML: true)
            mail.addAttachmentData(csvData!, mimeType: "svc", fileName: "TrackingStatistics")
            
            present(mail, animated: true)
            
        } else {
            
            let alert = UIAlertController(title: "", message: "Error", preferredStyle: .alert)
            present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


