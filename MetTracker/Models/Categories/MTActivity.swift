//
//  MTActivity.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 19.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTActivity: MTSearchObject {

    let activityId : Int
    let ainsworthCode : Int
    let mets : Float
    let name : String
    let orderNumber : Int
    let subcategory : String
    
    init(_ data : NSDictionary) {
        
        self.activityId = data.object(forKey: "ACTIVITY ID") as! Int
        self.ainsworthCode = data.object(forKey: "AINSWORTH CODE") as! Int
        self.mets = Float(data.object(forKey: "METS") as? Double ?? 0)
        self.name = data.object(forKey: LS("activity_name")) as! String
        self.orderNumber = data.object(forKey: "ORDER NUMBER") as! Int
        self.subcategory = data.object(forKey: "SUBCATEGORY") as! String
        
    }
    
    override func searchValue() -> String {
        return self.name
    }

}
