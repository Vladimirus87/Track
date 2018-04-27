//
//  AchievementDetailsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class AchievementDetailsViewController: MTViewController {

    @IBOutlet weak var categoryTitle: MTLabel!
    @IBOutlet weak var countOfMets: MTLabel!
    @IBOutlet weak var trackingTime: MTLabel!
    @IBOutlet weak var fullDescription: MTLabel!
    

    var tracking: Tracking?
    var categoryList  = DataManager.shared.categoryArray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let track = tracking else {return}
        dataForAlert(track)
    }
    
    func dataForAlert(_ track: Tracking) {
        
        let trackDate = (track.date as Date?) ?? Date()
        let min = track.time * 60 * 60
        let end = trackDate.addingTimeInterval(Double(min))
        let trackTime = minutesToHoursMinutes(minutes: min) ?? "--"
        
        categoryTitle.text = categoryList[Int(track.categoryId)].name
        countOfMets.text = "\(track.mets.rounded(toPlaces: 2)) METS"
        trackingTime.text = "\(trackDate.string(with: "HH:mm"))-\(end.string(with: "HH:mm")) | Tracking time \(trackTime)"
        
        guard let actId = tracking?.activityId, let catId = tracking?.categoryId else {
            return
        }
        let activivty = DataManager.shared.activity(Int(actId), fromCategory: Int(catId))
        fullDescription.text = "\(activivty?.name ?? "--")"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func okBtnPressed(_ sender: MTButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
