//
//  UIView+extension.swift
//  NihonGoal
//
//  Created by kuroro on 04/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//
import UIKit

extension UIView {
    func setGradient(firstColor: UIColor, secondColor: UIColor, rounded: Bool) {
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = [0, 1]
        self.layer.addSublayer(gradient)
        gradient.frame = self.frame
        if rounded {
            gradient.cornerRadius = gradient.bounds.width / 2
            gradient.borderWidth = 3
            gradient.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
