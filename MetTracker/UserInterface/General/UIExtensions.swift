//
//  UIExtensions.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 16.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import Foundation
import UIKit

func LS(_ S: String) -> String {

    return NSLocalizedString(S, comment: "")
    
}

extension UIImage {
    
    func tint(with color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension UIView {
    
    func roundCorners()
    {
        roundCorners(with: self.frame.size.height / 2.0)
    }
    
    func roundCorners(with radius: CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func addGradientWithColor(colorTop: UIColor, colorBottom: UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension UIFont {
    
    static func medium(_ size : CGFloat) -> UIFont {
        return UIFont.init(name: "Quicksand-Medium", size: size)!
    }
    
}

extension Date {
    var components:DateComponents {
        let cal = NSCalendar.current
        return cal.dateComponents(Set([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .yearForWeekOfYear]), from: self)
    }
    
    func add(days : Int) -> Date? {
        
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: self)
        
    }
}



extension Date {
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}




extension Int {
    static func random(from: Int, to: Int) -> Int {
        guard to > from else {
            assertionFailure("Can not generate negative random numbers")
            return 0
        }
        return Int(arc4random_uniform(UInt32(to - from)) + UInt32(from))
    }
}






