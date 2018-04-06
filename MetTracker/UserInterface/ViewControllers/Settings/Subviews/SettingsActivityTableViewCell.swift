//
//  SettingsActivityTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var imageConfirm: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var labelValue: MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithActivity(activity: MTActivity, isSelected: Bool) {
        
        imageConfirm.isHidden = !isSelected
        labelTitle.text = activity.name
        labelValue.text = String(format: "%.1f", activity.mets)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
