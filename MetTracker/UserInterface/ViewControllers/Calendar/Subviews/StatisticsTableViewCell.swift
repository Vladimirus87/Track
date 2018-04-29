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
    
    var mets = [[Float]]()
    var currentMonths = [Int]()
    
    var mostMet: Float = 0
    var mostActivity : String?
    

    var data = [String : Any]() {
        didSet {
            mets = data["mets"] as! [[Float]]
            currentMonths = data["currentMonths"] as! [Int]
            mostMet = data["mostMet"] as! Float
            mostActivity = data["mostActivity"] as? String
            valueWasChanged()
        }
    }
    
    func valueWasChanged() {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
