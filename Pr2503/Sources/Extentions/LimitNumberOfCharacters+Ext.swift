//
//  LimitNumberOfCharacters+Ext.swift
//  Pr2503
//
//  Created by Gabriel Zdravkovici on 14.11.2023.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
