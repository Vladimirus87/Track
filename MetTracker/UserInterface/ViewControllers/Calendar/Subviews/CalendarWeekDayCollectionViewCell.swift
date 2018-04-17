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
    
    func configureCell(date: Date, trDates: [Tracking]?, ip: IndexPath) {
        
//        DispatchQueue.main.async {
        
            self.labelWeekday.text = Calendar.current.shortWeekdaySymbols[ip.row]
            self.labelDay.text = date.string(with: "dd")
        
            let filteredArray = trDates!.filter { ($0.date as Date?)?.string(with: "ddMMyyyy") == date.string(with: "ddMMyyyy") }
            if filteredArray.count > 0 {
                self.backgroundColor = Config.shared.baseColor()
            }
        }
//    }
    
}
