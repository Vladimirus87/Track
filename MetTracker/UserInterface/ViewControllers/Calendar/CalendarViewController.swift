//
//  CalendarViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import Masonry

class CalendarViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewMonthWeek: UIView!
    
    @IBOutlet weak var viewVerticalBar: UIView!
    @IBOutlet weak var viewWeekNumber: MTView!
    
    @IBOutlet weak var buttonEnlarge: UIButton!
    
    @IBOutlet weak var buttonStatistics: UIButton!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "CalendarTableViewCell"
    var firstDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonEnlarge.roundCorners()
        //labelMonthWeek.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
    }
    
    override func resizeSubviews() {
        super.resizeSubviews()
        
        self.updateUIForDate(Date())
    }
    
    func getWeek(_ today : Date) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
        let myComponents = myCalendar.components(.weekOfYear, from: today)
        let weekNumber = myComponents.weekOfYear
        return weekNumber!
    }
    
    
    func getWeekFirstDay(from sourceDate:Date) -> Date? {
        let Calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var sourceComp = sourceDate.components
        var comp = DateComponents()
        comp.weekOfYear = sourceComp.weekOfYear
        comp.weekday = 1
        comp.yearForWeekOfYear = sourceComp.yearForWeekOfYear
        return Calendar.date(from: comp)
    }
    
    func updateUIForDate(_ date : Date) {
        
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM yyyy");
        
        let month = df.string(from: date).uppercased()
        let text = "\(month)  \(LS("week")) \(self.getWeek(date))"
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.medium(Config.shared.textSizeIsEnlarged() ? 24.0 : 20.0),
            NSAttributedStringKey.foregroundColor : UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)]

        let attributedText = NSMutableAttributedString.init(string: text, attributes: attributes)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange.init(location: 0, length: month.count))
        
        viewMonthWeek.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done

        let labelMonthWeek = UILabel.init()
        labelMonthWeek.attributedText = attributedText
        
        labelMonthWeek.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        labelMonthWeek.sizeToFit()
        
        viewMonthWeek.addSubview(labelMonthWeek)
        labelMonthWeek.mas_makeConstraints( { make in
            make?.centerX.equalTo()(10)
            make?.centerY.equalTo()(-(viewMonthWeek.frame.size.height - labelMonthWeek.frame.size.height) / 2.0)
        })
        
        self.firstDate = self.getWeekFirstDay(from: date)
        
        self.tableViewData.reloadData()
        
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.firstDate != nil else {
            return 0
        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalendarTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        cell.updateWithDate(date: self.firstDate?.add(days: indexPath.row))
        
        return cell
        
    }
    
    // MARK: - Notifications
    
    override func updateColorScheme() {
        
        self.viewVerticalBar.backgroundColor = Config.shared.baseColor()
        self.viewWeekNumber.backgroundColor = Config.shared.baseColor()
        self.buttonStatistics.tintColor = Config.shared.baseColor()
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
