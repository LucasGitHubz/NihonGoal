//
//  UINavigationBar+extension.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//
import UIKit

extension UINavigationBar {
    func setStyle(color: UIColor) {
        self.isHidden = false
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        self.topItem?.backBarButtonItem?.tintColor = color
        let barButton = UIBarButtonItem()
        barButton.title = ""
        barButton.tintColor = color
        self.topItem?.backBarButtonItem = barButton
    }
}
