//
//  DashboardHintTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//



import UIKit

protocol DashboardHintTableViewCellDelegate {
    func closeBtnPressed()
    func showSettingsBtnPressed()
}

class DashboardHintTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground : UIView!
    @IBOutlet weak var textLbl: MTLabel!
    
    var delegate: DashboardHintTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLbl.text = LS("did_you_know")
        viewBackground.backgroundColor = Config.shared.baseColor()
        
    }
    
    @IBAction func showSettingsPressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.showSettingsBtnPressed()
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.closeBtnPressed()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
