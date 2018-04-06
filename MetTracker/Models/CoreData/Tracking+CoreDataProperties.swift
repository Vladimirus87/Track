//
//  Tracking+CoreDataProperties.swift
//  
//
//  Created by Pavel Belevtsev on 02.04.2018.
//
//

import Foundation
import CoreData


extension Tracking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tracking> {
        return NSFetchRequest<Tracking>(entityName: "Tracking")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var activityId: Int64
    @NSManaged public var categoryId: Int64
    @NSManaged public var time: Float
    @NSManaged public var mets: Float
    @NSManaged public var heartrate: Int16

}
