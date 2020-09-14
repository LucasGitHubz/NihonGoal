//
//  KanaCell.swift
//  NihonGoal
//
//  Created by kuroro on 04/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class KanaCell: UITableViewCell, NibReusable {
    @IBOutlet weak var background: UIView!
    @IBOutlet var kanaLabel: [CustomConnexionLabel]!
    @IBOutlet var letterLabel: [CustomConnexionLabel]!
}
