//
//  MTProfile.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 09.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit


enum MTProfileGender: String {
    case male = "male"
    case female = "female"
}

class MTProfile: NSObject, NSCopying, NSCoding {
    
    var gender : MTProfileGender?
    var height : Int?
    var weight : Int?
    var age : Int?

    override init() {
        super.init()
        
    }
    
    init(gender: MTProfileGender?, height: Int?, weight: Int?, age: Int?) {
        self.gender = gender
        self.height = height
        self.weight = weight
        self.age = age
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let gender = MTProfileGender(rawValue: (aDecoder.decodeObject(forKey: "gender") as! String))
        let height = aDecoder.decodeInteger(forKey: "height")
        let weight = aDecoder.decodeInteger(forKey: "weight")
        let age = aDecoder.decodeInteger(forKey: "age")
        
        self.init(gender: gender, height: height, weight: weight, age: age)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MTProfile(gender: gender, height: height, weight: weight, age: age)
        return copy
    }
    
    func encode(with aCoder: NSCoder) {
        if let gender = self.gender as MTProfileGender! {
            aCoder.encode(gender.rawValue, forKey: "gender")
        }
        //aCoder.encode(self.gender!, forKey: "gender")
        aCoder.encode(self.height!, forKey: "height")
        aCoder.encode(self.weight!, forKey: "weight")
        aCoder.encode(self.age!, forKey: "age")
    }
    
    
    func value(_ key : String) -> Any? {
        
        if key == "gender" {
            return self.gender
        }
        if key == "height" {
            return self.height
        }
        if key == "weight" {
            return self.weight
        }
        if key == "age" {
            return self.age
        }
        
        return nil
    }
    
    func setValue(_ key : String, value : Any?) {
        
        if key == "gender" {
            self.gender = value as! MTProfileGender?
        }
        if key == "height" {
            self.height = value as! Int?
            if (self.height == 0) {
                self.height = nil
            }
        }
        if key == "weight" {
            self.weight = value as! Int?
            if (self.weight == 0) {
                self.weight = nil
            }
        }
        if key == "age" {
            self.age = value as! Int?
            if (self.age == 0) {
                self.age = nil
            }
        }
    }
    
    func clearData() {
        self.gender = nil
        self.height = nil
        self.weight = nil
        self.age = nil
    }
    
    func isCompleted() -> Bool {
        
        if let _ = self.gender,
            let _ = self.height,
            let _ = self.weight,
            let _ = self.age {
            
            return true
        } else {
            return false
        }
    }
   
    
}

