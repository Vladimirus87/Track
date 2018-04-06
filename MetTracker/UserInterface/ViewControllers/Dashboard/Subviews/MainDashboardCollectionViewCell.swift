//
//  MainDashboardCollectionViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MainDashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var viewSelected: UIView!
    
    func updateWithTabInfo(tabInfo: NSDictionary, isSelected: Bool) {

        self.viewSelected.backgroundColor = Config.shared.baseColor()
        
        let imageName = tabInfo.object(forKey: "image") as! String
        self.imageIcon.image = UIImage(named: imageName)
        
        if (isSelected) {
            self.imageIcon.image = self.imageIcon.image?.tint(with: self.viewSelected.backgroundColor!)
        }
        
        self.viewSelected.isHidden = !isSelected
        
    }
    
}
