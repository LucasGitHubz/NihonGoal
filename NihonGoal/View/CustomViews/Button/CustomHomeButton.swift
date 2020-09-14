//
//  CustomHomeButton.swift
//  NihonGoal
//
//  Created by kuroro on 07/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomHomeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    func setStyle() {
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.shadowOpacity = 0.9
    }
}
