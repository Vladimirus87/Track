//
//  CalendarViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import Masonry
import CoreData

class CalendarViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewMonthWeek: UIView!
    
    @IBOutlet weak var viewVerticalBar: UIView!
    @IBOutlet weak var viewWeekNumber: MTView!
    @IBOutlet weak var countOfMets: MTLabel!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var buttonEnlarge: UIButton!
    @IBOutlet weak var buttonChangeDate: UIButton!
    @IBOutlet weak var buttonStatistics: UIButton!
    
    @IBOutlet weak var tableViewData: UITableView!
    
    let cellIdentifier = "CalendarTableViewCell"
    var firstDate : Date?
    var carrentDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonEnlarge.roundCorners()
        self.buttonChangeDate.roundCorners()
        
        self.width.constant = Config.shared.textSizeIsEnlarged() ? 80 : 60
        self.height.constant = Config.shared.textSizeIsEnlarged() ? 80 : 60
        viewWeekNumber.layer.cornerRadius = self.height.constant / 2
        
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
        comp.weekday = 2
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
        
        if let firstD = firstDate {
            self.countOfMets.text = "\(summOfMet(firstD).rounded(toPlaces: 2))"
        }
        
    }
    
    
    
    @IBAction func changeDatePressed(_ sender: UIButton) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant:0).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 8).isActive = true
        
        let ok = UIAlertAction(title: LS("ok"), style: .default) { (action) in
            self.updateUIForDate(datePicker.date)
            self.carrentDate = datePicker.date
        }
        
        let cancel = UIAlertAction(title: LS("cancel"), style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
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
        cell.labelWeekday.updateTextSize()
        cell.labelDay.updateTextSize()
        cell.labelProgress.updateTextSize()
        
        return cell
        
    }
    
    // MARK: - Notifications
    
    override func updateColorScheme() {
        
        self.viewVerticalBar.backgroundColor = Config.shared.baseColor()
        self.viewWeekNumber.backgroundColor = Config.shared.baseColor()
        self.buttonStatistics.tintColor = Config.shared.baseColor()
        
        tableViewData.reloadData()
        
    }
    
    
    override func updateTextSize() {
       
        self.countOfMets.updateTextSize()
        self.buttonEnlarge.roundCorners()
        self.buttonChangeDate.roundCorners()
        self.width.constant = Config.shared.textSizeIsEnlarged() ? 80 : 60
        self.height.constant = Config.shared.textSizeIsEnlarged() ? 80 : 60
        viewWeekNumber.layer.cornerRadius = self.height.constant / 2
        updateUIForDate(carrentDate ?? Date())
        tableViewData.reloadData()
    }
    
    
    
    func summOfMet(_ first: Date) -> Float {
        var count: Float = 0
        do {
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [first.startOfDay, first.endOfWeek])
            
            
            let fetchRequest : NSFetchRequest<Tracking> = Tracking.fetchRequest()
            fetchRequest.predicate = datePredicate
            let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let data = try contex.fetch(fetchRequest)
            
            
            for i in data {
                count += i.mets
            }
        } catch {
            print("Fetching Failed")
           
        }
        return count
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    


    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toMonthCallendar", let destVC = segue.destination as? CalendarMonthViewController {
//            var sectionData = [(Int, Int)]()
//            for i in 0...5 {
//                let month = Calendar.current.date(byAdding: .month, value: -i, to: Date())
//                guard let mm = Int((month?.string(with: "MM"))!), let yy = Int((month?.string(with: "yyyy"))!) else { return }
//                sectionData.insert((mm,yy), at: 0)
//            }
//            destVC.sectionData = sectionData
//        }
//    }

}
