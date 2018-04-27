//
//  StatisticsTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 23.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewContent: MTView!

    var isWeekStatistics: Bool?
    
    var trakingData : [Tracking]?{
        didSet {
            getPeaks(data: trakingData!)
        }
    }
    
    var mets = [[Float]]()
    var currentMonths = [Int]()
    
    
    var mostMet: Float = 0
    var mostActivity : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lastMonthes(count: 6)
        getData()
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
    

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
