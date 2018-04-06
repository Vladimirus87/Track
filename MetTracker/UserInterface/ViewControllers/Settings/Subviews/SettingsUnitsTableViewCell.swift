//
//  SettingsUnitsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsUnitsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconSelected: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconSelected.isHidden = true
    }
    
    func updateWithData(data: [String : Any]) {
        
        let value = data["value"] as! Int
        if (value == Config.shared.units) {
            self.iconSelected.isHidden = false
        }
        
        if let title = data["title"] as? String {
            self.labelTitle.text = LS(title)
        }
        self.labelTitle.updateTextSize()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
