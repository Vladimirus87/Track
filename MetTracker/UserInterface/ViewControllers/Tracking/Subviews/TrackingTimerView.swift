//
//  TrackingTimerView.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 21.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

public protocol TrackingTimerViewDelegate : NSObjectProtocol {
    
    func timerIsUpdated(hours: Double, minutes: Double, seconds: Double)

}

public enum TrackingTimerState : Int32 {
    
    case initialized
    case running
    case paused
    case manual

}

class TrackingTimerView: UIView {

    @IBOutlet weak var gaugeMinutes: MTGauge!
    @IBOutlet weak var gaugeHours: MTGauge!

    @IBOutlet weak var buttonMinutes: UIButton!
    @IBOutlet weak var buttonHours: UIButton!
    
    @IBOutlet weak var constraintMinutesX: NSLayoutConstraint!
    @IBOutlet weak var constraintMinutesY: NSLayoutConstraint!
    @IBOutlet weak var constraintHoursX: NSLayoutConstraint!
    @IBOutlet weak var constraintHoursY: NSLayoutConstraint!

    var timer : Timer?
    var savedTime : TimeInterval = 0
    var startTime : NSDate?
    var seconds : TimeInterval = 0
    var minutes : Int = 0
    var hours : Int = 0
    var progressSeconds : CGFloat = 0.0
    var progressMinutes : CGFloat = 0.0
    var progressHours : CGFloat = 0.0
    
    weak var delegate : TrackingTimerViewDelegate?
    var state : TrackingTimerState = .initialized
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear;
        
        self.gaugeMinutes.updateWithProgress(0.0, width: 8, color: .white)
        self.gaugeHours.updateWithProgress(0.0, width: 8, color: .white)
     
        self.buttonMinutes.roundCorners()
        self.buttonMinutes.addTarget(self,
                                     action: #selector(drag(button:event:)),
                                     for: UIControlEvents.touchDragInside)
        self.buttonMinutes.addTarget(self,
                                     action: #selector(drag(button:event:)),
                                     for: [UIControlEvents.touchDragExit,
                                           UIControlEvents.touchDragOutside])

        self.buttonHours.roundCorners()
        self.buttonHours.addTarget(self,
                                     action: #selector(drag(button:event:)),
                                     for: UIControlEvents.touchDragInside)
        self.buttonHours.addTarget(self,
                                     action: #selector(drag(button:event:)),
                                     for: [UIControlEvents.touchDragExit,
                                           UIControlEvents.touchDragOutside])

    }
    
    @objc func drag(button: UIButton, event: UIEvent) {
        if let center = event.allTouches?.first?.location(in: self) {
            moveButton(button, toPoint:center)
        }
    }
    
    func moveButton(_ button : UIButton, toPoint : CGPoint)  {
        
        let isMinutes = (button == self.buttonMinutes)
        let gauge = isMinutes ? gaugeMinutes : gaugeHours
        
        let center = CGPoint.init(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        let r = (gauge!.frame.size.width - 8) / 2.0
        
        let dX = toPoint.x - center.x;
        let dY = toPoint.y - center.y;
        
        let valueLong = sqrt((dX * dX) + (dY * dY))
        
        let circlePoint = CGPoint.init(x: (((r * dX) / valueLong) + center.x), y: ((r * dY) / valueLong) + center.y)
        
        
        let angle = atan2(circlePoint.y - center.y, circlePoint.x - center.x);
        
        var progress : CGFloat = 0.0
        if (angle > 0) {
            progress = angle / (CGFloat.pi * 2.0)
            progress += 0.25
        } else {
            progress = CGFloat.pi + angle
            progress = progress / (CGFloat.pi * 2.0)
            progress += 0.75
            if (progress >= 1.0) {
                progress -= 1.0
            }
        }
        
        let priorProgress = isMinutes ? progressMinutes : progressHours
        
        if (abs(progress - priorProgress) > 0.5) {
            return
        }
        
        if (isMinutes) {
            progressMinutes = progress
            self.constraintMinutesX.constant = circlePoint.x - center.x
            self.constraintMinutesY.constant = circlePoint.y - center.y
        } else {
            progressHours = progress
            self.constraintHoursX.constant = circlePoint.x - center.x
            self.constraintHoursY.constant = circlePoint.y - center.y
        }
        
        self.layoutIfNeeded()
        
        if (isMinutes) {
            self.updateMinutes(Double(progress) * 60.0)
        } else {
            self.updateHours(Double(progress) * 12.0)
        }
    }
    
    func stopTimer() {
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    func startTimer() {
        
        self.buttonMinutes.isHidden = true
        self.buttonHours.isHidden = true
        
        self.state = .running
        
        self.stopTimer()
        
        self.startTime = NSDate.init()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTimer), userInfo: nil, repeats: true)
        
    }

    func pauseTimer() {
        
        self.state = .paused
        
        let time : TimeInterval = -(self.startTime?.timeIntervalSinceNow)!
        savedTime += time
        
        stopTimer()
        
    }
    
    func clearManual() {
        
        self.seconds = 0
        self.minutes = 0
        self.hours = 0
        self.savedTime = 0
        self.progressSeconds = 0.0
        self.progressMinutes = 0.0
        self.progressHours = 0.0
        
        self.updateTimer(0.0)
        
        self.state = .initialized
        
        self.constraintMinutesX.constant = 0
        self.constraintMinutesY.constant = -(self.gaugeMinutes!.frame.size.width - 8) / 2.0
        
        self.constraintHoursX.constant = 0
        self.constraintHoursY.constant = -(self.gaugeHours!.frame.size.width - 8) / 2.0
        
        self.layoutIfNeeded()
        
    }
    
    @objc func animateTimer() {
        
        if (self.startTime != nil) {
            
            var time : TimeInterval = -(self.startTime?.timeIntervalSinceNow)!
            time += savedTime
            
            self.updateTimer(time)
            
        }
        
    }
 
    func updateTimer(_ time : Double) {
        
        var seconds = time
        var minutes = seconds / 60;
        var hours = minutes / 60;
        
        seconds = seconds.truncatingRemainder(dividingBy: 60)
        minutes = minutes.truncatingRemainder(dividingBy: 60)
        hours = hours.truncatingRemainder(dividingBy: 12)
        
        self.gaugeMinutes.updateWithProgress(minutes / 60.0)
        self.gaugeHours.updateWithProgress(hours / 12.0)
        
        guard let delegate = self.delegate else {
            return
        }
        delegate.timerIsUpdated(hours: hours, minutes: minutes, seconds: seconds)
        
    }
    
    func updateMinutes(_ time : Double) {
        
        self.state = .manual
        self.minutes = Int(time)
        self.savedTime = Double(self.hours) + Double(self.minutes) + self.seconds
        self.gaugeMinutes.updateWithProgress(Double(minutes) / 60.0)
        
        guard let delegate = self.delegate else {
            return
        }
        delegate.timerIsUpdated(hours: Double(self.hours), minutes: Double(self.minutes), seconds: self.seconds)
        
    }
    
    func updateHours(_ time : Double) {
        
        self.state = .manual
        self.hours = Int(time)
        self.savedTime = Double(self.hours) + Double(self.minutes) + self.seconds
        self.gaugeHours.updateWithProgress(time / 12.0)
        
        guard let delegate = self.delegate else {
            return
        }
        delegate.timerIsUpdated(hours: Double(hours), minutes: Double(self.minutes), seconds: self.seconds)

    }
    
}
