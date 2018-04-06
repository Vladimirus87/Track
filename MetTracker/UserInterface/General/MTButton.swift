//
//  MTButton.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 19.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
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
        if let _ = self.titleLabel {
            self.textSizeForStandard = self.titleLabel!.font.pointSize
        }
        updateTextSize()
    }
    
    func updateTextSize() {
        let textSize = Config.shared.textSizeIsEnlarged() ? textSizeForEnlarged : textSizeForStandard
        
        if (textSize > 0) {
            if let _ = self.titleLabel {
                self.titleLabel!.font = UIFont.init(name: self.titleLabel!.font.fontName, size: textSize)
            }
        }
    }
    
}
