//
//  SettingsSubtitleTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsSubtitleTableViewCell: SettingsTableViewCell {

    @IBOutlet weak var labelSubtitle: MTLabel!
    
    var dashData = [LS("motivational_quotes"), LS("picture"), "crustanceans"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    

    override func updateWithData(data: NSDictionary) {
        super.updateWithData(data: data)
        
        if let title = data["title"] as? String {

            switch title {
                
            case "colour_options" :
                let colourData = Settings.shared.colors[UserDefaults.standard.value(forKey: "SettingsColor") as? Int ?? 0] as! [String : Any]
                let colour = colourData["title"] as! String
                self.labelSubtitle.text = LS(colour)
                
            case "text_size" :
                let textData = Settings.shared.textSizes[UserDefaults.standard.value(forKey: "SettingsTextSize") as? Int ?? 0] as! [String : Any]
                let size = textData["title"] as! String
                self.labelSubtitle.text = LS(size)
                
            case "dashboard_design" :
                let them = dashData[UserDefaults.standard.integer(forKey: "designTheme")]
                self.labelSubtitle.text = them//LS(size)
                
            case "units" :
                self.labelSubtitle.text = Config.shared.units == 0 ? "Metric" : "Imperial"
                
            default: self.labelSubtitle.text = ""
            }
        }
        
        self.labelSubtitle.updateTextSize()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
