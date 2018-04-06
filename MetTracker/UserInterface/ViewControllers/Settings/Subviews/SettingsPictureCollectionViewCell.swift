//
//  SettingsPictureCollectionViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

protocol PictureCellDelegate {
    func picturePressed(cell: UICollectionViewCell)
}

class SettingsPictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var checkBox: UIView!
    
    var delegate: PictureCellDelegate?
    
    var imageURL: String? {
        didSet{
            picture.image = nil
            updateUI()
        }
    }
    
    private func updateUI() {
        if let img = imageURL {
            DispatchQueue.global(qos: .utility).async {
                let contents = getImage(name: img + "small")
                DispatchQueue.main.async {
                    if let imageData = contents {
                        self.picture.image = imageData
                    } 
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func plusPressed(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.picturePressed(cell: self)
        }
    }
    

}
