//
//  Activity+CoreDataProperties.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 30.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var categoryId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var mets: Float
    @NSManaged public var name: String?
    @NSManaged public var order: Int16

}
