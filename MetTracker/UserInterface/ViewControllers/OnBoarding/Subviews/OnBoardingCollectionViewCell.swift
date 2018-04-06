//
//  OnBoardingCollectionViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol OnBoardingCollectionViewCellDelegate: class {
    func onBoardingActionPressed()
}
    
class OnBoardingCollectionViewCell: UICollectionViewCell {

    weak var delegate: OnBoardingCollectionViewCellDelegate?

    @IBOutlet weak var imageViewPage: UIImageView!
    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var labelText: MTLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func updateWithPageInfo(pageInfo: NSDictionary) {

        let imageName = pageInfo.object(forKey: "image") as! String
        self.imageViewPage.image = UIImage(named: imageName)
        self.labelTitle.text = LS(pageInfo.object(forKey: "title") as! String)
        self.labelText.text = LS(pageInfo.object(forKey: "text") as! String)
        
    }
    
    
}
