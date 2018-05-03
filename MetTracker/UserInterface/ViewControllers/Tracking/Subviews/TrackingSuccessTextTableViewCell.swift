//
//  TrackingSuccessTextTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class TrackingSuccessTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLbl: MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    infoLbl.text = LS("entered_succeessfully")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
