//
//  StatisticsPeaksTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsPeaksTableViewCell: StatisticsTableViewCell {

    @IBOutlet weak var titlePeaks: MTLabel!
    @IBOutlet weak var averagePerWeek: MTLabel!
    @IBOutlet weak var mostMeets: MTLabel!
    
    @IBOutlet weak var AvPerWeekCount: MTLabel!
    @IBOutlet weak var mostMetsCount: MTLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titlePeaks.text = LS("peaks")
        averagePerWeek.text = LS("average_per_week")
        mostMeets.text = LS("most_collected")
    }
    
    override func valueWasChanged() {
        AvPerWeekCount.text = "\(UserDefaults.standard.float(forKey: "MaxWeekResult"))"
        mostMetsCount.text = "\(mostMet)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
