//
//  Extension.swift
//  SAMI-LOTTERY
//
//  Created by Nguyễn Khoa on 10/18/17.
//  Copyright © 2017 Nguyễn Khoa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    
    func tfColor(color: UIColor) {
        self.textColor = color
        
    }
    func border(color: UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
}
