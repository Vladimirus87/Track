//
//  SettingsNotificationsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsNotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var labelText: MTLabel!
    
    var field: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithData(data: [String : Any]) {
        
        if let title = data["title"] as? String {
            self.labelTitle.text = LS(title)
        }
        
        
        if let text = data["text"] as? String {
            self.labelText.text = LS(text)
        }
        
        self.field = data["field"] as? String
        if let field = self.field {
            self.switchNotification.isOn = Config.shared.notificationValue(field)
        }
        
    }
    
    @IBAction func switchNotificationValueChanged(_ sender: UISwitch) {
        
        if let field = self.field {
            Config.shared.setNotificationValue(field, value: self.switchNotification.isOn)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
