//
//  SettingsQuickAccessTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol SettingsQuickAccessTableViewCellDelegate: class {
    func quickAccessRemovePressed(_ activity: Activity)
}


class SettingsQuickAccessTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var buttonHandle: UIButton!

    var delegate: SettingsQuickAccessTableViewCellDelegate?
    var activity: Activity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithActivity(activity: Activity) {
        self.activity = activity
        labelTitle.text = activity.name
        
    }
    
    // MARK: - Actions
    @IBAction func buttonRemovePressed(_ sender: UIButton) {
        
        if let activity = self.activity,
            let delegate = self.delegate {
            delegate.quickAccessRemovePressed(activity)
        }
        
    }
    
    @IBAction func buttonMovePressed(_ sender: UIButton) {
    }
    
    // MARK: -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
