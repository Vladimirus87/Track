//
//  StatisticsPeaksTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsPeaksTableViewCell: StatisticsTableViewCell {

    @IBOutlet weak var gaugeProgress: MTGauge!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gaugeProgress.updateWithProgress(12.0 / 18.0, width: 8.0, color: Config.shared.baseColor())
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
