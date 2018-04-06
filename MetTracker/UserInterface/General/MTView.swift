//
//  MTView.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 25.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.cornerRadius = layer.cornerRadius
        }
    }
    
}
