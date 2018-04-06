//
//  DashboardInfoTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

protocol DashboardInfoTableViewCellDelegate {
    func infoBtnPressed()
}

class DashboardInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLbl: MTLabel!
    
    var delegate: DashboardInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.infoBtnPressed()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
