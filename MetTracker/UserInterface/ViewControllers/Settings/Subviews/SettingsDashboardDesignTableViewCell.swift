//
//  SettingsDashboardDesignTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsDashboardDesignTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameOfDesign: MTLabel!
    @IBOutlet weak var check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
