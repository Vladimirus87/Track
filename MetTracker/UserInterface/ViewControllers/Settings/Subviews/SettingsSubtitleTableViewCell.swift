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
    
    let colorIndex = UserDefaults.standard.value(forKey: "SettingsColor") as? Int ?? 0
    let textSizeIndex = UserDefaults.standard.value(forKey: "SettingsTextSize") as? Int ?? 0

    let dashThem = UserDefaults.standard.integer(forKey: "designTheme")
    var dashData = ["motivational quotes", "picture", "crustanceans"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func updateWithData(data: NSDictionary) {
        super.updateWithData(data: data)
        
        if let title = data["title"] as? String {

            switch title {
                
            case "colour_options" :
                let colourData = Settings.shared.colors[colorIndex] as! [String : Any]
                let colour = colourData["title"] as! String
                self.labelSubtitle.text = LS(colour)
                
            case "text_size" :
                let textData = Settings.shared.textSizes[textSizeIndex] as! [String : Any]
                let size = textData["title"] as! String
                self.labelSubtitle.text = LS(size)
                
            case "dashboard_design" :
                let them = dashData[dashThem]
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
