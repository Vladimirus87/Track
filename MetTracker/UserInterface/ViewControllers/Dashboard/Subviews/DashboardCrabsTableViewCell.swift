//
//  DashboardCrabsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 13.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DashboardCrabsTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    
    var countOfMets: Float? {
        didSet {
            DispatchQueue.main.async {
                var index: Int? {
                    get {
                        var tempInt = 0
                        if Int(self.countOfMets ?? 3) < 3 {
                            tempInt = 3
                        } else if Int(self.countOfMets ?? 3) > 18 {
                            tempInt = 18
                        } else {
                            tempInt = Int(self.countOfMets ?? 3)
                        }
                        print("countOfMets", Int(self.countOfMets!))
                        print("jjjjj", tempInt/3)
                        return tempInt/3
                    }
                    
                }
                if let image = UIImage(named: "crabs\(index ?? 1)"){
                    self.background.image = image
                }
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
