//
//  DashboardHintTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardHintTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackground.backgroundColor = Config.shared.baseColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
