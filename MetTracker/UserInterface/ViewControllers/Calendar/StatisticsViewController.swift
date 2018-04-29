//
//  StatisticsViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 15.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsViewController: MTViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewData: UITableView!
    
    var isWeekStatistics = true
    
    var trakingData : [Tracking]? {
        didSet {
            getPeaks(data: trakingData!)
        }
    }
    
    var mets = [[Float]]()
    var currentMonths = [Int]()
    
    
    var mostMet: Float = 0
    var mostActivity : String?
    
    
    let cellIdentifiers = ["StatisticsTrendTableViewCell", "StatisticsPeaksTableViewCell", "StatisticsFavoriteTableViewCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        lastMonthes(count: 6)
        
        for cellIdentifier in cellIdentifiers {
            self.tableViewData.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }

    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = cellIdentifiers[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StatisticsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        
        let sendingData: [String: Any] = ["mets": mets, "currentMonths": currentMonths, "mostMet": mostMet, "mostActivity": mostActivity]
        
        cell.isWeekStatistics = isWeekStatistics
        cell.data = sendingData

        return cell
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("statistics")
         
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func lastMonthes(count: Int) {
        for i in 0...count - 1 {
            let month = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            if let mm_Month = Int((month?.string(with: "MM"))!){
                currentMonths.insert(mm_Month, at: 0)
            }
        }
    }
    
    func getWeek(_ today : Date) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
        let myComponents = myCalendar.components(.weekOfYear, from: today)
        let weekNumber = myComponents.weekOfYear
        return weekNumber!
    }
    
    func getData() {
        do {
            let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            self.trakingData = try contex.fetch(Tracking.fetchRequest()) as? [Tracking]
            
        } catch {
            print("Fetching Failed")
        }
    }
    
    
    func getPeaks(data: [Tracking]) {
        var activities = [String]()
        var maxMets = [Float]()
        
        for i in 0...5 {
            let month = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            var _mets: [Float] = [0]
            
            
            for track in data {
                if (track.date as Date?)?.string(with: "MM.yyyy") == month?.string(with: "MM.yyyy") {
                    _mets.append(track.mets)
                    if let string = DataManager.shared.activity(Int(track.activityId), fromCategory: Int(track.categoryId)) {
                        activities.append(string.name)
                    }
                }
            }
            
            maxMets.append(_mets.max() ?? 0)
            self.mets.insert(_mets, at: 0)
        }
        
        self.mostMet = maxMets.max() ?? 0
        let countedSet = NSCountedSet(array: activities)
        let mostFrequent = countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) }
        
        mostActivity = mostFrequent as? String
    }
}
