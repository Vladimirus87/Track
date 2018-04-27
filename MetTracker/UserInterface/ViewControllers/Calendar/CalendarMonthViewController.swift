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
    
    let cellIdentifier = "CalendarWeekTableViewCell"
    let headerIdentifier = "CalendarMonthTitleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...5 {
            let month = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            if let mm = Int((month?.string(with: "MM"))!), let yy = Int((month?.string(with: "yyyy"))!) {
                if let arr = mondays(myYear: yy, myMonth: mm) {
                    data.insert(arr, at: 0)
                }
            }
        }
        
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        
        buttonStatistic.tintColor = Config.shared.baseColor()

        
        calendarTableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        calendarTableView.register(UINib.init(nibName: headerIdentifier, bundle: nil), forCellReuseIdentifier: headerIdentifier)
       }

    
    
    override func updateColorScheme() {
        enlargeBtn.roundCorners()
    }

    
   
    
    override func viewDidLayoutSubviews() {
        let offsetOfTable = CGPoint(x:0, y:self.calendarTableView.contentSize.height - self.calendarTableView.frame.size.height)
        self.calendarTableView.contentOffset = offsetOfTable
    }
    
    // MARK: - TavleView
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
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
        
        let date = data[section].last
        let mm = date?.string(with: "MMMM") ?? ""
        let yy = date?.string(with: "yyyy") ?? ""
        
        header?.labelTitle.text = "\(mm)" + " " + "\(yy)"
        
        return header
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
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
        
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .month, for: date)!
        
        let days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
        
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
