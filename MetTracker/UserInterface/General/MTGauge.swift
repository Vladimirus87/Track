//
//  MTGauge.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 21.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTGauge: UIView {

    var progress = 0.0
    var width = 0.0
    var color : UIColor?
    
    func updateWithProgress(_ progress : Double, width : Double, color : UIColor) {
        
        self.progress = progress;
        self.width = width
        self.color = color
        
        self.setNeedsDisplay()
    }
    
    func updateWithProgress(_ progress : Double) {
        
        self.progress = progress;
        
        self.setNeedsDisplay()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if (width > 0.0) {
            let r = Double(self.frame.size.width / 2.0)
            
            let pathCircle =  UIBezierPath(arcCenter: CGPoint(x: r,y: r), radius: CGFloat(r - (width / 2.0)), startAngle: CGFloat(0.0), endAngle:CGFloat(Double.pi * 2.0), clockwise: true)
            pathCircle.lineWidth = CGFloat(width)
            pathCircle.lineCapStyle = .round
            guard let strokeColorCircle = self.color else {
                return
            }
            strokeColorCircle.setStroke()
            pathCircle.stroke(with: .normal, alpha: 0.2)
            
            if (progress > 0.0) {
                let path =  UIBezierPath(arcCenter: CGPoint(x: r,y: r), radius: CGFloat(r - (width / 2.0)), startAngle: CGFloat(-Double.pi / 2.0), endAngle:CGFloat((Double.pi * 2.0 * progress) - (Double.pi / 2.0)), clockwise: true)
                path.lineWidth = CGFloat(width)
                path.lineCapStyle = CGLineCap.round
                guard let strokeColor = self.color else {
                    return
                }
                strokeColor.setStroke()
                path.stroke()
            }
        }
    }
    

}
