//
//  MTCategory.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 19.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTCategory: MTSearchObject {

    let categoryId : Int
    let name : String
    let icon : String
    var activities = [MTActivity]()
    
    init(_ data : NSDictionary) {
        
        self.categoryId = data.object(forKey: "CATEGORY ID") as! Int
        self.name = data.object(forKey: "CATEGORY NAME") as! String
        self.icon = data.object(forKey: "ICON") as! String
        
        let fileName = "Category\(self.categoryId)"
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        for item in array! {
            
            let activity = MTActivity.init(item as! NSDictionary)
            self.activities.append(activity)
            
        }
        
    }
    
    override func searchValue() -> String {
        return self.name
    }
    
}
