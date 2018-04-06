//
//  CalendarTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var viewVerticalBar: UIView!
    @IBOutlet weak var viewWeekday: UIView!
    @IBOutlet weak var labelWeekday: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var constraintProgress: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewWeekday.isHidden = true;
        labelWeekday.textColor = .black
        
    }
    
    func updateWithDate(date: Date?) {

        guard date != nil else {
            return
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date!)

        labelDay.text = "\(day)."
     
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("E");
        
        labelWeekday.text = df.string(from: date!)
        
        if (labelWeekday.text != nil && labelWeekday.text!.count > 2) {
            labelWeekday.text = String(labelWeekday.text!.prefix(2))
        }
        
        if (calendar.isDateInToday(date!)) {
            viewWeekday.isHidden = false;
            labelWeekday.textColor = Config.shared.baseColor()
        }
        
        let progress = arc4random_uniform(5) + 3
        self.labelProgress.text = "\(progress)"
        self.constraintProgress.constant = 22.0 * CGFloat(progress)
        self.layoutIfNeeded()
        
        self.viewVerticalBar.backgroundColor = Config.shared.baseColor()
        self.viewProgress.backgroundColor = Config.shared.baseColor()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
