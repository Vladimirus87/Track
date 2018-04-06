//
//  TrackingCategoryTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class TrackingCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithCategory(category: MTCategory) {
        
        self.contentView.backgroundColor = Config.shared.darkColor()
        
        imageIcon.image = UIImage.init(named: category.icon)?.tint(with: UIColor.white)
        labelTitle.text = category.name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
