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
    
    
    @IBOutlet weak var exportBtn: MTButton!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var infoLbl: MTLabel!
    
    var data = [Tracking]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataFullList : [MTCategory]!
    var activities = [MTActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataFullList = DataManager.shared.categoryArray
        getData()
        
        self.labelTitle.text = LS("export_tracks")
        self.infoLbl.text = LS("you_can_send_your_tracking")
        self.exportBtn.setTitle(LS("send_tracks"), for: .normal)
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
    
    

    func getDataOfActivity(ctId: Int, actId: Int) -> MTActivity? {
        
        let actArr = dataFullList[ctId - 1].activities
        for activity in actArr {
            if activity.activityId == actId {
                return activity
            }
        }
        return nil
    }
    
    
    @IBAction func exportPressed(_ sender: MTButton) {
        exportDatabase()
    }
    
    
    
    
    func exportDatabase() {
        let exportString = createExportString()
        sendEmail(exportString: exportString)
    }
    
    
    func createExportString() -> String {
        var name : String
        var date : Date
        var heartrate : Int16
        var time : Float
        var mets : Float
        
        var export : String = "ACTIVITY NAME, HEART RATE, START TIME, END TIME, TOTAL TIME, METS, \r"
        
        for (_ , itemList ) in data.enumerated() {
            
            let _name = getDataOfActivity(ctId: Int(itemList.categoryId), actId: Int(itemList.activityId))
            name = _name?.name ?? "--"
            let _date = itemList.date! as Date
            date = _date
            heartrate = itemList.heartrate
            time = itemList.time
            mets = itemList.mets
            
            let promoName = "\(name)"
            let promoHeartrate = "\(heartrate)"
            let startTime = date.string(with: "dd-MM-yyyy HH:mm")
            
            let min = time * 60 * 60
            let end = date.addingTimeInterval(Double(min))
            let endTime = end.string(with: "dd-MM-yyyy HH:mm")
            
            let tuple = minutesToHoursMinutes(minutes: min) ?? "--"
            let totalTime = "\(tuple)"
            let promoMets = "\(mets.rounded(toPlaces: 2))"
            
            export +=
                  "\"" + promoName      + "\"" + ","
                + "\"" + promoHeartrate + "\"" + ","
                + "\"" + startTime      + "\"" + ","
                + "\"" + endTime        + "\"" + ","
                + "\"" + totalTime      + "\"" + ","
                + "\"" + promoMets      + "\"" + "\r"
        }
        
        return export
    }
    
    func minutesToHoursMinutes (minutes : Float) -> String? {
        
        
        let duration: TimeInterval = Double(minutes)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .hour, .minute]
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let formattedDuration = formatter.string(from: duration)
        
        return formattedDuration
    }
    
    
    
    override func updateColorScheme() {
        exportBtn.backgroundColor = Config.shared.baseColor()
    }
    
}





extension SettingsMiscActivitiesViewController: MFMailComposeViewControllerDelegate {

    
    func sendEmail(exportString: String) {
        
        let data = exportString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            mail.setMessageBody("<p>MET Tracker</p>", isHTML: true)
            mail.addAttachmentData(data!, mimeType: "text/csv", fileName: "MET Tracker.csv")
            
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


