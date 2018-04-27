//
//  DashboardPictureTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class DashboardPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var weekCounts: MTLabel!
    @IBOutlet weak var dayOfWeek: MTLabel!
    @IBOutlet weak var metsProgress: UILabel!
    @IBOutlet weak var roundProgress: MTGauge!
    
    
    var pictureData = [Design](){
        didSet{
            prepareForReuse()
        }
    }
    
    var _weekCounts: Int?{
        didSet{
            weekCounts.text = "\(LS("week")) \(_weekCounts!)".uppercased()
        }
    }
    var _dayOfWeek: String? {
        didSet{
            dayOfWeek.text = _dayOfWeek!
        }
    }
    var _roundProgress: Double? {
        didSet{
            roundProgress.updateWithProgress(_roundProgress! / 18.0, width: 15.0, color: .white)
        }
        
    }
    var _countOfMeets: Float?{
        didSet{
            let formattedString = NSMutableAttributedString()
            let metsProgInfo = formattedString.bold("\(_countOfMeets?.rounded(toPlaces: 2) ?? 0)").normal("/18")
            metsProgress.attributedText = metsProgInfo
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        for img in pictureData {
            if img.selected {
                if let imgUrl = img.picturePath {
                    DispatchQueue.global(qos: .utility).async {
                        let contents = getImage(name: imgUrl )
                        DispatchQueue.main.async {
                            if let imageData = contents {
                                self.picture.image = imageData
                            }
                        }
                    }
                }
            }
        }
    }

    


    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}




