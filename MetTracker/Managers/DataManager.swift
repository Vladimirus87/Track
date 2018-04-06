//
//  DataManager.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 19.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {

    static let shared = DataManager()

    var categoryArray = [MTCategory]()
    var quickAccessArray = [Activity]()
    var nextOrder = 0
    
    override init() {
        super.init()
        
    }
    
    func loadData() {
        
        categoryArray.removeAll()
        
        let fileName = "Categories"
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let array = NSArray(contentsOfFile: path!)

        for item in array! {
            
            let category = MTCategory.init(item as! NSDictionary)
            categoryArray.append(category)
            
        }
        
        loadQuickAccessList()
        
    }
    
    func activityInQuickAccessList(_ activityId : Int) -> Bool {
        
        for activity in quickAccessArray {
            if activity.id == activityId {
                return true
            }
            
        }
        return false
    }
    
    func addActivity(_ activity: MTActivity, category: MTCategory)  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        let newActivity = NSManagedObject(entity: entity!, insertInto: context)
        
        newActivity.setValue(activity.activityId, forKey: "id")
        newActivity.setValue(category.categoryId, forKey: "categoryId")
        newActivity.setValue(activity.name, forKey: "name")
        newActivity.setValue(activity.mets, forKey: "mets")
        newActivity.setValue(nextOrder, forKey: "order")
        nextOrder = nextOrder + 1
        quickAccessArray.append(newActivity as! Activity)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func removeActivity(_ id: Int)  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
            
            loadQuickAccessList()
        }
    }
    
    func loadQuickAccessList() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        let sort = NSSortDescriptor(key: #keyPath(Activity.order), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        //request.predicate = NSPredicate(format: "age = %@", "12")
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest)
            quickAccessArray.removeAll()
            quickAccessArray.append(contentsOf: result)
            updateQuickAccessOrder()
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func updateQuickAccessOrder() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        nextOrder = 0
        for activity in quickAccessArray {
            activity.order = Int16(nextOrder)
            nextOrder = nextOrder + 1
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func replaceQuickAccessItem(_ sourceId: Int, withItem destinationId: Int) {
        
        if let indexSource = quickAccessItemIndex(sourceId),
            let indexDestination = quickAccessItemIndex(destinationId) {
            
            let item = quickAccessArray[indexSource]
            quickAccessArray.remove(at: indexSource)
            quickAccessArray.insert(item, at: indexDestination)
            
        }
        
        updateQuickAccessOrder()
        
    }
    
    func quickAccessItemIndex(_ activityId: Int) -> Int? {
        for (index, element) in quickAccessArray.enumerated() {
            if element.id == activityId {
                return index
            }
        }
        return nil
    }
    
    func activity(_ activityId: Int, fromCategory categoryId: Int) -> MTActivity? {
        
        if (categoryId <= self.categoryArray.count) {
            let category = self.categoryArray[categoryId - 1]
            for activity in category.activities {
                if activity.activityId == activityId {
                    return activity
                }
            }
        }
        return nil;
    }
    
}
