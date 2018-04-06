//
//  StatisticsFavoriteTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsFavoriteTableViewCell: StatisticsTableViewCell {

    @IBOutlet weak var viewActivityInfo: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewActivityInfo.backgroundColor = Config.shared.baseColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
