//
//  MTViewController.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 14.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MTViewController: UIViewController, UIGestureRecognizerDelegate {

    var isResized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateLocalization()
        
        let tapKeyboard = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
        tapKeyboard.cancelsTouchesInView = false
        tapKeyboard.delegate = self;
        self.view.addGestureRecognizer(tapKeyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateColorScheme), name: Notification.Name(Config.notificationSettingsColor), object: nil)

        self.updateColorScheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextSize), name: Notification.Name(Config.notificationSettingsTextSize), object: nil)

    }

    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // Mark: - Resizing
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!self.isResized) {
            self.isResized = true
            
            resizeSubviews()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeKeyboard()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func resizeSubviews() {
        
        
    }
    
    func updateLocalization() {
        
    }
    
    @objc func closeKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(_ notification : NSNotification) {
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.updateKeyboardHeight(targetFrame.size.height);
    }
    
    @objc func keyboardWillHide(_ notification : NSNotification) {
        self.updateKeyboardHeight(0.0);
    }
    
    func updateKeyboardHeight(_ height : CGFloat) {
        
    }
    
    // Mark: - Notifications
    
    @objc func updateColorScheme() {
        
    }
    
    @objc func updateTextSize() {
        
    }
    
    // Mark: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
    
    // Mark: -
    
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
