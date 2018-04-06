//
//  MTLabel.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 06.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTLabel: UILabel {

    var textSizeForStandard : CGFloat = 0.0
    
    var textSizeForEnlarged : CGFloat = 0.0
    @IBInspectable var textSizeEnlarged: CGFloat {
        get {
            return textSizeForEnlarged
        }
        set {
            textSizeForEnlarged = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textSizeForStandard = self.font.pointSize
        updateTextSize()
    }
    
    func updateTextSize() {
        let textSize = Config.shared.textSizeIsEnlarged() ? textSizeForEnlarged : textSizeForStandard
        
        if (textSize > 0) {
            self.font = UIFont.init(name: self.font.fontName, size: textSize)
        }
    }
    
    
}
