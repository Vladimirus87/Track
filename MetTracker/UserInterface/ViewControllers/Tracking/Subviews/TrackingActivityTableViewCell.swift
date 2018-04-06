//
//  TrackingSubCategoryTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class TrackingActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var imageConfirm: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var labelValue: MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageConfirm.image = UIImage.init(named: "icon_confirm")?.tint(with: UIColor.white)
    }

    func updateWithQuickAccessActivity(activity: Activity, isSelected: Bool) {
        
        self.contentView.backgroundColor = Config.shared.darkColor()
        
        imageConfirm.isHidden = !isSelected
        labelTitle.text = activity.name
        labelValue.text = String(format: "%.1f", activity.mets)
        
    }
    
    func updateWithActivity(activity: MTActivity, isSelected: Bool) {
        
        self.contentView.backgroundColor = Config.shared.darkColor()
        
        imageConfirm.isHidden = !isSelected
        labelTitle.text = activity.name
        labelValue.text = String(format: "%.1f", activity.mets)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
