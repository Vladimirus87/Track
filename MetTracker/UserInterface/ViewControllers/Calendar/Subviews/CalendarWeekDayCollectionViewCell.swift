//
//  CalendarWeekDayCollectionViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CalendarWeekDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelWeekday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        backgroundColor = .clear
    }
    
    func configureCell(date: String, trDates: [Tracking]?, weekday: String) {
        
        self.labelWeekday.text = weekday
        self.labelDay.text = String(date.prefix(2))
        
            let filteredArray = trDates!.filter { ($0.date as Date?)?.string(with: "ddMMyyyy") == date }
            if filteredArray.count > 0 {
                self.backgroundColor = Config.shared.baseColor()
            }
        }
//    }
    
}
