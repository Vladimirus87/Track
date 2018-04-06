//
//  Config.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 23.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class Config: NSObject {

    static let notificationSettingsColor = "NotificationSettingsColor"
    static let notificationSettingsTextSize = "NotificationSettingsTextSize"
    
    static let shared = Config()
    
    var notificationLaziness : Bool = false {
        willSet(newNotificationLaziness) {
            
        }
        didSet {
            if notificationLaziness != oldValue  {
                
            }
        }
    }
    
    var notificationEndWeek : Bool = false {
        willSet(newNotificationEndWeek) {
            
        }
        didSet {
            if notificationEndWeek != oldValue  {
                
            }
        }
    }
    
    var colourOptions : Int = UserDefaults.standard.object(forKey: "SettingsColor") as? Int ?? 0 {
        willSet(newColourOptions) {
            
        }
        didSet {
            if colourOptions != oldValue  {
                NotificationCenter.default.post(name: Notification.Name(Config.notificationSettingsColor), object: nil)

            }
        }
    }
    
    var textSize : Int = UserDefaults.standard.object(forKey: "SettingsTextSize") as? Int ?? 0 {
        willSet(newTextSize) {
            
        }
        didSet {
            if textSize != oldValue  {
                NotificationCenter.default.post(name: Notification.Name(Config.notificationSettingsTextSize), object: nil)
             
                
            }
        }
    }
    
    var units : Int = 0 {
        willSet(newUnits) {
            
        }
        didSet {
            if units != oldValue  {
                
            }
        }
    }
    
    var profile : MTProfile = MTProfile() {
        willSet(newProfile) {
            
        }
        didSet {
            
            if (profile.isCompleted()) {
                self.writeObject(profile, filename: "profile.plist")
            }
            
        }
    }
    
    override init() {
        super.init()
        
        let fullPath = getDocumentsPath("profile.plist")
        
        if let object = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath) as? MTProfile {
            self.profile = object
        }
        
    }
    
    func getDocumentsPath(_ filename : String) -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return (url!.appendingPathComponent(filename).path)
    }
    
    func writeObject(_ object : Any, filename : String) {
        let fullPath = getDocumentsPath(filename)
        NSKeyedArchiver.archiveRootObject(object, toFile: fullPath)
    }
    
    func readObject(_ object : Any, filename : String) {
        
    }
    
    // Mark: - Notifications
    
    func notificationValue(_ key : String) -> Bool {
        
        if key == "notificationLaziness" {
            return self.notificationLaziness
        }
        if key == "notificationEndWeek" {
            return self.notificationEndWeek
        }
        
        return false
    }
    
    func setNotificationValue(_ key : String, value : Bool) {
        
        if key == "notificationLaziness" {
            self.notificationLaziness = value
        }
        if key == "notificationEndWeek" {
            self.notificationEndWeek = value
        }
        
    }

    // Mark: - Colors
    
    func baseColor() -> UIColor {
        return Settings.shared.colorForIndex(colourOptions)
    }

    func baseColor(_ alpha : CGFloat) -> UIColor {
        return Settings.shared.colorForIndex(colourOptions, alpha : alpha)
    }
    
    func darkColor() -> UIColor {
        return Settings.shared.darkColorForIndex(colourOptions)
    }

    // Mark: - Text size
    
    func textSizeIsEnlarged() -> Bool {
        return (textSize == 1)
    }

    // Mark: - Units
    
    func unitsIsMetric() -> Bool {
        return (units == 0)
    }
    
}
