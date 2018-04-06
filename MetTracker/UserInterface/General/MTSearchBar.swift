//
//  MTSearchBar.swift
//  MetTracker
//
//  Created by Pavel Belevtsev on 19.02.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol MTSearchBarDelegate: class {
    func searchBarText(_ search: String?)
}

class MTSearchBar: UIView, UITextFieldDelegate {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var delegate: MTSearchBarDelegate?

    override func awakeFromNib() {
        
        viewContent.roundCorners(with: 8.0);
        textFieldSearch.delegate = self;
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if (delegate != nil) {
            let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            delegate!.searchBarText(newText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if (delegate != nil) {
            delegate!.searchBarText(nil)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}
