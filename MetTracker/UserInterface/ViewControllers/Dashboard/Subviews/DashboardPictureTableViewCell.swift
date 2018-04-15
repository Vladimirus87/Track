//
//  DashboardPictureTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pictureData = [Design]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        
        getData()
        
        for img in pictureData {
            if img.selected {
                if let imgUrl = img.picturePath {
                    DispatchQueue.global(qos: .utility).async {
                        let contents = getImage(name: imgUrl + "small")
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

    
    func getData() {
        do {
            pictureData = try contex.fetch(Design.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
