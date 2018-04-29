//
//  StatisticsFavoriteTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsFavoriteTableViewCell: StatisticsTableViewCell {

    @IBOutlet weak var favouriteTitle: MTLabel!
    @IBOutlet weak var favouriteAct: MTLabel!
    @IBOutlet weak var viewActivityInfo: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favouriteTitle.text = LS("favour_activity")
        
        self.viewActivityInfo.backgroundColor = Config.shared.baseColor()
    }
    
    override func valueWasChanged() {
        favouriteAct.text = mostActivity
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
