//
//  Settings.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 05.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class Settings: NSObject {

    static let shared = Settings()
    
    var colors : NSArray!
    var textSizes : NSArray!
    var personalData : NSArray!
    var notifications : NSArray!
    var units : NSArray!
    
    override init() {
        super.init()
        
        let pathColors = Bundle.main.path(forResource: "SettingsColor", ofType: "plist")
        colors = NSArray(contentsOfFile: pathColors!)

        let pathTextSizes = Bundle.main.path(forResource: "SettingsTextSize", ofType: "plist")
        textSizes = NSArray(contentsOfFile: pathTextSizes!)

        let pathPersonalData = Bundle.main.path(forResource: "SettingsPersonalData", ofType: "plist")
        personalData = NSArray(contentsOfFile: pathPersonalData!)

        let pathNotifications = Bundle.main.path(forResource: "SettingsNotifications", ofType: "plist")
        notifications = NSArray(contentsOfFile: pathNotifications!)

        let pathUnits = Bundle.main.path(forResource: "SettingsUnits", ofType: "plist")
        units = NSArray(contentsOfFile: pathUnits!)

    }
    
    func colorForIndex(_ index : Int) -> UIColor {
        return colorForIndex(index, alpha : 1.0)
    }
    
    func colorForIndex(_ index : Int, alpha : CGFloat) -> UIColor {
    
        let dict = colors[index] as! [String : Any]
        let color = dict["color"] as! [String : NSNumber]
        
        return colorFromData(color, alpha : alpha)
        
    }
    
    func darkColorForIndex(_ index : Int) -> UIColor {
        
        let dict = colors[index] as! [String : Any]
        let color = dict["dark_color"] as! [String : NSNumber]
        
        return colorFromData(color)
        
    }
    
    func colorFromData(_ data : [String : NSNumber]) -> UIColor {
        return colorFromData(data, alpha: 1.0)
    }
    
    func colorFromData(_ data : [String : NSNumber], alpha : CGFloat) -> UIColor {
        
        return UIColor.init(red: CGFloat(data["red"]!.floatValue / 255.0),
                            green: CGFloat(data["green"]!.floatValue / 255.0),
                            blue: CGFloat(data["blue"]!.floatValue / 255.0), alpha: alpha)
        
    }
    
    
}
