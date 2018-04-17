//
//  CalendarTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var viewVerticalBar: UIView!
    @IBOutlet weak var viewWeekday: UIView!
    @IBOutlet weak var labelWeekday: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var constraintProgress: NSLayoutConstraint!
    
    var data = [Tracking]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        updateProgress(withPredicate: date!)
        
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
        
        
        
        self.layoutIfNeeded()
        
        self.viewVerticalBar.backgroundColor = Config.shared.baseColor()
        self.viewProgress.backgroundColor = Config.shared.baseColor()
    }
    
    
    
    func updateProgress(withPredicate: Date) {
    
        do {
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [withPredicate.startOfDay, withPredicate.endOfDay])
            
            
            let fetchRequest : NSFetchRequest<Tracking> = Tracking.fetchRequest()
            fetchRequest.predicate = datePredicate
            data = try contex.fetch(fetchRequest)
            var countOfMets: Float = 0
            for i in data {
                countOfMets += i.mets
            }
            
            labelProgress.text = "\(countOfMets.rounded(toPlaces: 2))"

            let progMaxWidth = (contentView.frame.width) - viewProgress.frame.origin.x
            let countMets = countOfMets > 50.0 ? 50.0 : countOfMets
            let percentFromMets = (countMets * 100) / 50
            let progressWidth = progMaxWidth * CGFloat(percentFromMets) / 100
            self.constraintProgress.constant = progressWidth
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
//        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    var endOfWeek : Date {
        var components = DateComponents()
        components.day = 7
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
}

