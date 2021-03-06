//
//  AchievementTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

protocol AchievementsTableViewCellDelegate {
    func delete(cell: UITableViewCell)
}

class AchievementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: MTLabel!
    @IBOutlet weak var category: MTLabel!
    @IBOutlet weak var time: MTLabel!
    @IBOutlet weak var mets: MTLabel!
    
    var categoryList  = DataManager.shared.categoryArray
    
    var delegate: AchievementsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        self.addGestureRecognizer(gesture)
    }
    
    
    func dataForCell(_ track: Tracking) {
        
        let trackDate = (track.date as Date?) ?? Date()
        let min = track.time * 60 * 60
        let end = trackDate.addingTimeInterval(Double(min))
        let trackTime = minutesToHoursMinutes(minutes: min) ?? "--"
        
        category.text = categoryList[Int(track.categoryId - 1)].name
        date.text = trackDate.string(with: "dd-MM-yyyy")
        mets.text = "\(track.mets.rounded(toPlaces: 2))"
        let timerTrack = track.isManual ? "" : "\(trackDate.string(with: "HH:mm"))-\(end.string(with: "HH:mm")) | "
        
        time.text = timerTrack + "\(LS("tracking_time")) \(trackTime)"
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
    
    @objc func longGesture() {
        if let delegate = delegate {
            delegate.delete(cell: self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
