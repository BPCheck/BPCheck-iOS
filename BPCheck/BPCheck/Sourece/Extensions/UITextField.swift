//
//  UITextField.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/04.
//

import UIKit

extension UITextField {
    
    func defaultRoundTextField() {
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        autocorrectionType = UITextAutocorrectionType.no
        font = UIFont.systemFont(ofSize: 13)
        borderStyle = UITextField.BorderStyle.roundedRect
        clearButtonMode = UITextField.ViewMode.whileEditing;
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
}
