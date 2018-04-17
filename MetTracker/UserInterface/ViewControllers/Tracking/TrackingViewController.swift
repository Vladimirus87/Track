//
//  TrackingViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import Masonry

class TrackingViewController: MTViewController, TrackingTimerViewDelegate {

    @IBOutlet weak var labelTitle: MTLabel!
    
    
    @IBOutlet weak var viewTopbar: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var viewHeart: UIView!
    @IBOutlet weak var buttonHeart: UIButton!
    
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var viewTimerControl: UIView!
    @IBOutlet weak var buttonTimerControl: UIButton!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var trackingTimer : TrackingTimerView?
    
    
    var isFirstRun = true// instead this var will use bottom var
    ///Code for show OnBoardingViewController only once(with first start app)
    /*    var isFirstRun: Bool {
     get { return UserDefaults.standard.value(forKey: "isFirstTrackingRun") as? Bool ?? true }
     set {
     let userDefaults = UserDefaults.standard
     userDefaults.set(newValue, forKey: "isFirstTrackingRun")
     userDefaults.synchronize()
     }
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelTimer.text = "0:00:00"
        TrackingManager.shared.reset()
        
        self.viewHeart.roundCorners()
        self.viewTimerControl.roundCorners()
        
        trackingTimer = (Bundle.main.loadNibNamed("TrackingTimerView", owner: nil, options: nil)![0] as! TrackingTimerView)
        trackingTimer?.delegate = self
        viewTimer.addSubview(trackingTimer!)
        
        trackingTimer?.mas_makeConstraints( { make in
            _ = make?.edges.equalTo()(viewTimer)
        })
        
        updateTimerControlButton(#imageLiteral(resourceName: "icon_play"), isInverted: false)
        
        
        
        if (isFirstRun) {
            
            isFirstRun = false
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            controller.currentPageSet = 1
            let navigation = UINavigationController.init(rootViewController: controller)
            navigation.setNavigationBarHidden(true, animated: false)
            self.present(navigation, animated: true)
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.trackingTimer?.stopTimer()
        
    }
    
    override func resizeSubviews() {
        super.resizeSubviews()
        
        updateUI()
        
    }
    
    // MARK: - TrackingTimerViewDelegate
        
    func timerIsUpdated(hours: Double, minutes: Double, seconds: Double) {
        
        self.labelTimer.text = "\(String(format: "%d", Int(hours))):\(String(format: "%.2d", Int(minutes))):\(String(format: "%.2d", Int(seconds)))"
        
        guard let trackingTimer = self.trackingTimer else {
            return
        }
        
        if (trackingTimer.state == .manual) {
            updateTimerControlButton(#imageLiteral(resourceName: "icon_reset"), isInverted: true)
        }
        
        guard let config = TrackingManager.shared.config else {
            return
        }
        
        config.seconds = (Int(hours) * 3600) + (Int(minutes) * 60) + Int(seconds)
        
        updateConfirmAvailable()
    }
        
    // MARK: - UI
    
    func updateUI() {
        
        guard let config = TrackingManager.shared.config else {
            return
        }
        
        if (config.heartrate > 0) {
            self.buttonHeart.backgroundColor = .white
            self.buttonHeart.tintColor = Config.shared.baseColor()
            self.buttonHeart.setImage(nil, for: .normal)
            self.buttonHeart.setTitle(String(config.heartrate), for: .normal)
        } else {
            self.buttonHeart.backgroundColor = Config.shared.baseColor()
            self.buttonHeart.tintColor = .white
            self.buttonHeart.setImage(#imageLiteral(resourceName: "icon_heart"), for: .normal)
            self.buttonHeart.setTitle(nil, for: .normal)
        }
        
        updateConfirmAvailable()
        
    }
    
    func updateConfirmAvailable() {
        
        self.buttonConfirm.isEnabled = false
        
        guard let trackingTimer = self.trackingTimer else {
            return
        }
        guard let config = TrackingManager.shared.config else {
            return
        }
        
        if  (config.seconds > 1) {
         
            if ((trackingTimer.state == .manual) || (trackingTimer.state == .paused)) {
                self.buttonConfirm.isEnabled = true
            }
            
        }
        
    }
    
    func updateTimerControlButton(_ image : UIImage, isInverted : Bool) {
        
        buttonTimerControl.setImage(image, for: .normal)
        if (isInverted) {
            buttonTimerControl.tintColor = .white
            viewTimerControl.backgroundColor = self.viewTopbar.backgroundColor
        } else {
            buttonTimerControl.tintColor = self.viewTopbar.backgroundColor
            viewTimerControl.backgroundColor = .white
        }
    }
    
    // MARK: - Actions
    
    @IBAction func buttonTimerPressed(_ sender: UIButton) {
        
        guard let trackingTimer = self.trackingTimer else {
            return
        }
        
        if ((trackingTimer.state == .initialized) || (trackingTimer.state == .paused)) {
            trackingTimer.startTimer()
            updateTimerControlButton(#imageLiteral(resourceName: "icon_pause"), isInverted: true)
        } else if (trackingTimer.state == .running) {
            trackingTimer.pauseTimer()
            updateTimerControlButton(#imageLiteral(resourceName: "icon_play"), isInverted: false)
        } else if (trackingTimer.state == .manual) {
            trackingTimer.clearManual()
            updateTimerControlButton(#imageLiteral(resourceName: "icon_play"), isInverted: false)
        }
        
        self.updateUI()
        
    }
    
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToTracking(segue:UIStoryboardSegue) {
        
        if segue.identifier == "unwindToTrackingFromHeartrate" {
            updateUI()
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ShowHeartratePopover" {
            segue.destination.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            segue.destination.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        }
        
    }
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        self.viewTopbar.backgroundColor = Config.shared.baseColor()
        self.viewContent.backgroundColor = Config.shared.darkColor()
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("track_time")
        
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
