//
//  UIImageView+extension.swift
//  NihonGoal
//
//  Created by kuroro on 11/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

extension UIImageView {
    func blurImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.opacity = 0.7
        self.addSubview(blurEffectView)
    }
}
