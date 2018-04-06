//
//  OnBoardingButonCollectionViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class OnBoardingButonCollectionViewCell: OnBoardingCollectionViewCell {
    
    @IBOutlet weak var buttonAction: MTButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func updateWithPageInfo(pageInfo: NSDictionary) {

        super.updateWithPageInfo(pageInfo: pageInfo)
        
        guard let buttonTitle = pageInfo.object(forKey: "button") as? String else {
            return
        }
        self.buttonAction.setTitle(LS(buttonTitle), for:UIControlState.normal)
        self.buttonAction.backgroundColor = Config.shared.baseColor()
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonActionPressed(_ sender: UIButton) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.onBoardingActionPressed()
        
    }
    
}
