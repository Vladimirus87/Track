//
//  CalendarMonthViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CalendarMonthViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var buttonStatistic: UIButton!
    @IBOutlet weak var enlargeBtn: UIButton!
    
    var data = [[Date]]()
    var sectionData = [(04,2018), (05,2018), (06,2018)]
    
    let cellIdentifier = "CalendarWeekTableViewCell"
    let headerIdentifier = "CalendarMonthTitleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        for i in sectionData {
            guard let arr = mondays(myYear: i.1, myMonth: i.0) else { return }
            data.append(arr)
        }
        
        
        calendarTableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        calendarTableView.register(UINib.init(nibName: headerIdentifier, bundle: nil), forCellReuseIdentifier: headerIdentifier)
        
        
        buttonStatistic.tintColor = Config.shared.baseColor()
        
    }
    
    override func updateColorScheme() {
        enlargeBtn.roundCorners()
    }

    
    // MARK: - TavleView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CalendarWeekTableViewCell
        
        cell.data = getDaysOfWeek(date: data[indexPath.section][indexPath.row])
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = calendarTableView.dequeueReusableCell(withIdentifier: headerIdentifier) as? CalendarMonthTitleTableViewCell
        
        
        header?.labelTitle.text = "\(Calendar.current.standaloneMonthSymbols[sectionData[section].0])" + " " + "\(sectionData[section].1)"
        
        return header
    }
    
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        DispatchQueue.main.async {
//            
//        }
//        
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Calendar.current.monthSymbols[sectionData[section].0 - 1]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //-------
    func mondays(myYear: Int, myMonth: Int) -> [Date]? {
        var dates = [Date]()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        
        var comps = DateComponents(year: myYear, month: myMonth,
                                   weekday: calendar.firstWeekday, weekdayOrdinal: 1)
        guard let first = calendar.date(from: comps)  else { return nil }
        comps.weekdayOrdinal = -1
        guard let last = calendar.date(from: comps) else { return nil }
        guard let weeks = calendar.dateComponents([.weekOfMonth], from: first, to: last).weekOfMonth else { return nil }
        
        for i in 1...(weeks + 1) {
            comps.weekdayOrdinal = -i
            
            if let mnd = calendar.date(from: comps) {
                dates.insert(mnd, at: 0)
            }
        }
        
        return dates
    }
    
    
    
    
    func getDaysOfWeek(date: Date) -> [Date] {
        
//        var arr = [Date]()
        
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .month, for: date)!
        
        let days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd"
//        for date in days {
//            arr.append(formatter.string(from: date))
//        }
        
        return days
    }
    
    
    // MARK: - Actions
    
    @IBAction func enlargePressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMonth", let destVC = segue.destination as? StatisticsViewController {
            destVC.isWeekStatistics = false
        }
    }
    

}
