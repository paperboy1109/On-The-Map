//
//  UserInfoTextDelegate.swift
//  On-The-Map
//
//  Created by Daniel J Janiak on 7/2/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import UIKit

class UserInfoTextDelegate: NSObject, UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //If this is the first time entering text, clear the text field
        if let text = textField.text where text.isEmpty
        {
            textField.placeholder = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}