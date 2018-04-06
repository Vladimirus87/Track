//
//  MTTracking.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 23.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTTracking: NSObject {

    var seconds : Int = 0
    var heartrate : Int = 0
    var activityId : Int = 0
    var categoryId : Int = 0
    
    func reset() {
        
        self.seconds = 0
        self.heartrate = 0
        self.activityId = 0
        self.categoryId = 0
        
    }
    
}
