//
//  CustomProfilUIView.swift
//  NihonGoal
//
//  Created by kuroro on 11/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import Foundation

import UIKit

class CustomProfilUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    func setStyle() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowOpacity = 0.2
    }
}
