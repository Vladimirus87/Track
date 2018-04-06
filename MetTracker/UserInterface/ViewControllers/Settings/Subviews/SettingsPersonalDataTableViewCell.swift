//
//  SettingsPersonalDataTableViewCell.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 17.02.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol SettingsPersonalDataTableViewCellDelegate: class {
    func settingsPersonalDataIsUpdated()
}

class SettingsPersonalDataTableViewCell: UITableViewCell, UITextFieldDelegate {

    weak var delegate: SettingsPersonalDataTableViewCellDelegate?

    @IBOutlet weak var labelTitle: MTLabel!
    @IBOutlet weak var constraintTitle: NSLayoutConstraint!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var imageSelect: UIImageView!
    
    let limitLength = 3
    var profile : MTProfile?
    var data: [String : Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.constraintTitle.constant = 0
        self.textFieldValue.text = ""
        self.textFieldValue.isUserInteractionEnabled = true
        self.imageSelect.isHidden = true
        
    }
    
    
    func updateWithData(data: [String : Any], profile: MTProfile) {
        
        self.data = data
        self.profile = profile
        
        if let title = data["title"] as? String {
            self.labelTitle.text = LS(title)
        }
        self.labelTitle.updateTextSize()
        
        let selectable = data["selectable"]
        if (selectable != nil) {
            self.textFieldValue.isUserInteractionEnabled = false
            self.imageSelect.isHidden = false
        }
        
        let field = data["field"] as! String
        
        if let value = profile.value(field) {
            
            self.textFieldValue.text = String(describing: value)
            self.constraintTitle.constant = -20.0
            
        } else {
            self.textFieldValue.text = ""
        }
        
        
        self.layoutIfNeeded()
        
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
            
            if result {
                
                if (newLength > 0) && (self.constraintTitle.constant == 0.0) {
                    self.constraintTitle.constant = -20.0
                    self.layoutIfNeeded()
                } else if (newLength == 0) && (self.constraintTitle.constant < 0.0) {
                    self.constraintTitle.constant = 0.0
                    self.layoutIfNeeded()
                }
                
            }
            
            if (result) {
                let newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                
                let value = Int(newValue)
                let field = self.data!["field"] as! String
                self.profile!.setValue(field, value: value)
                
                if let delegate = self.delegate {
                    delegate.settingsPersonalDataIsUpdated()
                }
                
            }
        }
        
        
        return result
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
    
        self.constraintTitle.constant = 0.0
        self.layoutIfNeeded()
        
        return true
        
    }

    // MARK: -
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
