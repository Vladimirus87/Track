//
//  SettingsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 23.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var imageArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageArrow.isHidden = false
    }
    
    func updateWithData(data: NSDictionary) {

        let imageName = data.object(forKey: "icon") as! String
        self.imageIcon.image = UIImage(named: imageName)
        
        let title = data.object(forKey: "title") as! String
        self.labelTitle.text = LS(title)
        self.labelTitle.updateTextSize()
        
        let hideArrow = data.object(forKey: "hide_arrow")
        if (hideArrow != nil) {
            self.imageArrow.isHidden = true
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
