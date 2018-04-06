//
//  TrackingManager.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 23.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class TrackingManager: NSObject {

    static let shared = TrackingManager()
    
    var config : MTTracking?
    
    override init() {
        super.init()
        
    }
    
    func reset() {
        self.config = MTTracking()
    }
    
    
    func saveTracking(tracking: MTTracking) {
        
        if let activity = DataManager.shared.activity(tracking.activityId, fromCategory: tracking.categoryId) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Tracking", in: context)
            let newTracking = NSManagedObject(entity: entity!, insertInto: context) as! Tracking
            
            newTracking.date = NSDate.init()
            newTracking.activityId = Int64(tracking.activityId)
            newTracking.categoryId = Int64(tracking.categoryId)
            newTracking.time = Float(Double(tracking.seconds) / 3600.0)
            newTracking.mets = newTracking.time * activity.mets
            newTracking.heartrate = Int16(tracking.heartrate)
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
            
        }
        
    }
    
}
