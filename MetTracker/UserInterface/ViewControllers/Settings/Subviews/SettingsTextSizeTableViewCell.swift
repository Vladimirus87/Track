//
//  SettingsTextSizeTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTextSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var iconSelected: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var iconTextSize: UIImageView!
    
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
        if (value == Config.shared.textSize) {
            self.iconSelected.isHidden = false
        }
        
        if let title = data["title"] as? String {
            self.labelTitle.text = LS(title)
        }
        self.labelTitle.updateTextSize()
        
        let imageName = data["icon"] as! String
        self.iconTextSize.image = UIImage(named: imageName)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
