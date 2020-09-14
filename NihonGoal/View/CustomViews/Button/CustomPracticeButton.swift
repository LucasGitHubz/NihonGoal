//
//  CustomPracticeButton.swift
//  NihonGoal
//
//  Created by kuroro on 08/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomPracticeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    func setStyle() {
        self.layer.cornerRadius = 7
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0.4980838895, green: 0.4951269031, blue: 0.5003594756, alpha: 0.6851455479)
        self.layer.shadowOpacity = 0.5
    }
}
