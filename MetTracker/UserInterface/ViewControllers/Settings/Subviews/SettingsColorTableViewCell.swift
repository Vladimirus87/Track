//
//  SettingsColorTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsColorTableViewCell: UITableViewCell {

    @IBOutlet weak var viewColor: MTView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var iconSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconSelected.isHidden = true
        
    }

    
    func updateWithData(data: [String : Any]) {

        let color = data["color"] as! [String : NSNumber]
        viewColor.backgroundColor = Settings.shared.colorFromData(color)
        
        if let title = data["title"] as? String {
            self.labelTitle.text = LS(title)
        }
        
        let value = data["value"] as! Int
        if (value == Config.shared.colourOptions) {
            self.iconSelected.isHidden = false
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
