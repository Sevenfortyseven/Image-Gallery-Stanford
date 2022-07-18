//
//  UIViewController+.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import UIKit

extension UIViewController
{
    
    /// Hide keyboard when taps occur on the screen
    public func hideKeyboardOnTouches() {
        let tapOnScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapOnScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnScreen)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
