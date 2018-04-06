//
//  SettingsCategoryTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var imageArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithCategory(category: MTCategory) {
        
        imageIcon.image = UIImage.init(named: category.icon)?.tint(with: UIColor.black)
        labelTitle.text = category.name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
