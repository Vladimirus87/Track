//
//  HeartFrequencyViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class HeartFrequencyViewController: MTViewController, UITextFieldDelegate {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelTitle: MTLabel!
    
    @IBOutlet weak var viewHeartrate: UIView!
    @IBOutlet weak var textFieldHeartrate: UITextField!
    
    @IBOutlet weak var buttonConfirm: MTButton!
    @IBOutlet weak var buttonDismiss: MTButton!
    
    let limitLength = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (TrackingManager.shared.config!.heartrate > 0) {
            self.textFieldHeartrate.text = String(TrackingManager.shared.config!.heartrate)
        }
        
    }

    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        var result = (string == numberFiltered)
        
        if (result == true) {
            guard let text = textField.text else { return result }
            let newLength = text.count + string.count - range.length
            result = (newLength <= limitLength)
        }
        
        return result
    }
    
    // MARK: -
    
    override func resizeSubviews() {
        super.resizeSubviews()
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonConfirmPressed(_ sender: MTButton) {

        let heartrate = self.textFieldHeartrate.text
        if ((heartrate != nil) && (heartrate!.count > 0)) {
            TrackingManager.shared.config?.heartrate = Int(heartrate!)!
        } else {
            TrackingManager.shared.config?.heartrate = 0
        }
        self.performSegue(withIdentifier: "unwindToTrackingFromHeartrate", sender: self)
        
    }
    
    @IBAction func buttonDismissPressed(_ sender: UIButton) {
    
        self.performSegue(withIdentifier: "unwindToTrackingFromHeartrate", sender: self)
        
    }
    
    // Mark: - Notifications
    
    override func updateColorScheme() {
        self.buttonConfirm.backgroundColor = Config.shared.darkColor()
    }
    
    // MARK: - Localization
    
    override func updateLocalization() {
        
        self.labelTitle.text = LS("enter_your_heartrate")
        self.textFieldHeartrate.placeholder = LS("enter_bpm")
        self.buttonDismiss.setTitle(LS("button_dismiss"), for: .normal)
    }
    
    // MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
