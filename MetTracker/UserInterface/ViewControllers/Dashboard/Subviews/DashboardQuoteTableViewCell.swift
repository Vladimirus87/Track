//
//  DashboardQuoteTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardQuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var labelQuote : MTLabel!
    @IBOutlet weak var labelAuthor : MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let subviews = self.contentView.subviews
        
        for subview : AnyObject in subviews {
            if let viewToColor = subview as? UIView {
                if let labelToColor = viewToColor as? UILabel {
                    if labelToColor != labelAuthor {
                        labelToColor.textColor = Config.shared.baseColor()
                    }
                } else {
                    viewToColor.backgroundColor = Config.shared.baseColor()
                }
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
