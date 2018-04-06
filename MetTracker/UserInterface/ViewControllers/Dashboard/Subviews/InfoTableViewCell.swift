//
//  InfoTableViewCell.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 06.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var textInfo: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
