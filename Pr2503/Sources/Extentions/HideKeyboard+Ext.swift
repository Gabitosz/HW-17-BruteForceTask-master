//
//  HideKeyboard+Ext.swift
//  Pr2503
//
//  Created by Gabriel Zdravkovici on 12.11.2023.
//

import UIKit

extension UIViewController {
    
    func hideKeyBoardWhenTappedArround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
