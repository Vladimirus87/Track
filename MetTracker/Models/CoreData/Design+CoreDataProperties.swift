//
//  Design+CoreDataProperties.swift
//  MetTracker
//
//  Created by Владимир Моисеев on 05.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//
//

import Foundation
import CoreData


extension Design {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Design> {
        return NSFetchRequest<Design>(entityName: "Design")
    }

    @NSManaged public var picturePath: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var selected: Bool

}
